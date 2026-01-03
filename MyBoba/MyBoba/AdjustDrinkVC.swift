import UIKit

class AdjustDrinkVC: UIViewController {
    
    // Update the values passed from DrinkVC
    var drinkInAdjustDrinkVC: Drink?
    var countInAdjustDrinkVC: Int?
    var totalPriceInAdjustDrinkVC: Double?
    var imageInAdjustDrinkVC: UIImage?

    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var drinkImage: UIButton!
    // Total price in the bottom + toppings (optional)
    @IBOutlet weak var bottomTotalLabel: UILabel!
    
    // Size Properties
    var sizePrice: Double = 0.0
    var sizeItself: String = "M"
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeSlider: UISlider!
    
    @IBAction func sizePushed(_ sender: UISlider) {
        let step: Float = 50
        let roundedValue = round(sizeSlider.value / step) * step
        sizeSlider.value = roundedValue // snap slider to step
        
        switch roundedValue {
        case 0:
            sizeLabel.text = "Size: H (Hot)"
            sizeItself = "H"
            sizePrice = 0.0
        case 50:
            sizeLabel.text = "Size: M (Medium)"
            sizeItself = "M"
            sizePrice = 0.0
        case 100:
            sizeLabel.text = "Size: L (Large) +$1.00"
            sizeItself = "L"
            sizePrice = 1.0
        default:
            sizeLabel.text = "Size: M (Medium)"
            sizeItself = "M"
            sizePrice = 0.0
        }
        
        updateTotalPrice()
    }
    
    // Ice Level Properties
    var iceItself: String = "Regular Ice"
    
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var iceSlider: UISlider!
    
    @IBAction func icePushed(_ sender: UISlider) {
        let step: Float = 50
        let roundedValue = round(iceSlider.value / step) * step
        iceSlider.value = roundedValue
        
        switch roundedValue {
        case 0:
            iceLabel.text = "Ice Level: No Ice"
            iceItself = "No Ice"
        case 50:
            iceLabel.text = "Ice Level: Less Ice"
            iceItself = "Less Ice"
        case 100:
            iceLabel.text = "Ice Level: Regular Ice"
            iceItself = "Regular Ice"
        case 150:
            iceLabel.text = "Ice Level: More Ice"
            iceItself = "More Ice"
        default:
            iceLabel.text = "Ice Level: Regular Ice"
            iceItself = "Regular Ice"
        }
    }
    
    // Sugar Level Properties
    var sugarItself: String = "100% Sugar"
    
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var sugarSlider: UISlider!
    
    @IBAction func sugarPushed(_ sender: UISlider) {
        let step: Float = 50
        let roundedValue = round(sugarSlider.value / step) * step
        sugarSlider.value = roundedValue
        
        switch roundedValue {
        case 0:
            sugarLabel.text = "Sugar Level: 0%"
            sugarItself =  "0% Sugar"
        case 50:
            sugarLabel.text = "Sugar Level: 30%"
            sugarItself =  "30% Sugar"
        case 100:
            sugarLabel.text = "Sugar Level: 60%"
            sugarItself =  "60% Sugar"
        case 150:
            sugarLabel.text = "Sugar Level: 100% (Regular)"
            sugarItself =  "100% Sugar"
        case 200:
            sugarLabel.text = "Sugar Level: 120%"
            sugarItself =  "120% Sugar"
        default:
            sugarLabel.text = "Sugar Level: 100%"
            sugarItself =  "100% Sugar"
        }
    }
    
    // Topping Properties
    var selectedTopping: UIButton?
    var basePrice: Double = 0.0
    
    @IBOutlet weak var pearlsButton: UIButton!
    @IBOutlet weak var puddingButton: UIButton!
    @IBOutlet weak var coconutJellyButton: UIButton!
    @IBOutlet weak var redBeansButton: UIButton!
    
    @IBAction func toppingButtonTapped(_ sender: UIButton) {
        // CASE 1 — Tapped the same topping -> deselect it
        if selectedTopping == sender {
            // remove highlight
            sender.backgroundColor = .white
            
            selectedTopping = nil
            
            updateTotalPrice() // reset to base price
            return
        }
        
        // CASE 2 — Tapped a new topping -> switch selection
        // remove highlight from previous
        selectedTopping?.backgroundColor = .white

        // highlight new button
        sender.backgroundColor = .lightGray
        
        selectedTopping = sender
            
        updateTotalPrice()
    }
    
    // Capture the data - "Add to Bag" button
    @IBAction func addToBagTapped(_ sender: UIButton) {
        guard let drink = drinkInAdjustDrinkVC,
              let count = countInAdjustDrinkVC else { return }
        
        // MAKE SURE the price is up to date
        updateTotalPrice()
        
        let toppingName = selectedTopping?.titleLabel?.text
        
        let newItem = OrderItemDrinks(
            name: drink.name,
            price: totalPriceInAdjustDrinkVC ?? basePrice,
            quantity: count,
            toppings: toppingName,
            size: sizeItself,
            ice: iceItself,
            sugar: sugarItself
        )
        
        Cart.shared.addDrink(newItem)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Size Default
        sizeLabel.text = "Size: M"
        sizeSlider.value = 50
        
        // Ice Default
        iceLabel.text = "Ice Level: Regular Ice"
        iceSlider.value = 100
        
        // Sugar Default
        sugarLabel.text = "Sugar Level: 100%"
        sugarSlider.value = 150
        
        // Safely unwrap the values passed from DrinkVC
        if let drink = drinkInAdjustDrinkVC,
           let total = totalPriceInAdjustDrinkVC,
           let count = countInAdjustDrinkVC,
           let image = imageInAdjustDrinkVC {
            drinkLabel.text = drink.name
            priceLabel.text = "Price: $\(String(format: "%.2f", total))"
            amountLabel.text = "Amount: \(count)"
            drinkImage.setImage(image, for: .normal)
            bottomTotalLabel.text = "Price: $\(String(format: "%.2f", total))"
            
            // Update the base price for the toppings added
            basePrice = total
            
            // Update Ice Level for Mango Smoothie
            if drink.iceLevels == [100] {
                // Cannot do no ice for the Smoothie
                iceLabel.text = "Ice Level: Regular Sugar (Fixed)"
                iceSlider.isEnabled = false
            }
            
            // No toppings allowed
            if drink.toppings == [] {
                pearlsButton.isEnabled = false
                puddingButton.isEnabled = false
                coconutJellyButton.isEnabled = false
                redBeansButton.isEnabled = false
            }
            
            // Only size M available
            if drink.availableSizes == [.medium] {
                sizeLabel.text = "Size: M (Fixed)"
                sizeSlider.isEnabled = false
            }
        }
    }
    
    // Helper Methods
    func updateTotalPrice() {
        let toppingPrice = (selectedTopping == nil) ? 0.0 : 0.75
        let newTotal = basePrice + sizePrice + toppingPrice
        totalPriceInAdjustDrinkVC = newTotal

        bottomTotalLabel.text = "Price: $\(String(format: "%.2f", newTotal))"
    }
}
