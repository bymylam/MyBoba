import UIKit

class DrinkVC: UIViewController {
    
    // Drink Menu
    let drinks: [Drink] = [
        // Boba Milk Tea
        Drink(image: UIImage(named: "bobaTea")!,
              name: "Boba Milk Tea",
              basePrice: 5.25,
              availableSizes: [.hot, .medium, .large],
              sugarLevels: [0,30,60,100,120],
              iceLevels: [0,50,100,120],
              toppings: [.pearls, .pudding, .coconutJelly, .redBeans]),
        // Matcha Latte
        Drink(image: UIImage(named: "matcha")!,
              name: "Matcha Latte",
              basePrice: 5.75,
              availableSizes: [.hot, .medium, .large],
              sugarLevels: [0,30,60,100,120],
              iceLevels: [0,50,100,120],
              toppings: [.pearls, .pudding, .coconutJelly, .redBeans]),
        // Cocoa Milk
        Drink(image: UIImage(named: "cocoaMilk")!,
              name: "Cocoa Milk",
              basePrice: 5.50,
              availableSizes: [.hot, .medium, .large],
              sugarLevels: [0,30,60,100,120],
              iceLevels: [0,50,100,120],
              toppings: [.pearls, .pudding, .coconutJelly, .redBeans]),
        // Vietnamese Coffee
        Drink(image: UIImage(named: "coffee")!,
              name: "Vietnamese Coffee",
              basePrice: 4.75,
              availableSizes: [.hot, .medium, .large],
              sugarLevels: [0,30,60,100,120],
              iceLevels: [0,50,100,120],
              toppings: [.pearls, .pudding, .coconutJelly, .redBeans]),
        // Colorful Fruit Tea
        Drink(image: UIImage(named: "kiwi")!,
              name: "Colorful Fruit Tea",
              basePrice: 6.50,
              availableSizes: [.hot, .medium, .large], // no hot
              sugarLevels: [0,30,60,100,120],
              iceLevels: [0,50,100,120],
              toppings: []), // no toppings allowed
        // Mango Smoothies
        Drink(image: UIImage(named: "mango")!,
              name: "Mango Smoothies",
              basePrice: 5.25,
              availableSizes: [.medium], // fixed size
              sugarLevels: [0,30,60,100,120],
              iceLevels: [100], // fixed ice
              toppings: []), // no toppings allowed
    ]
    
    var drinkInDrinkVC: Drink?
    var countInDrinkVC: Int = 1
    var totalPriceInDrinkVC: Double?
    var imageInDrinkVC: UIImage?

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var drinkStepper: UIStepper!
    
    @IBAction func drinkStepperChanged(_ sender: UIStepper) {
        countInDrinkVC = Int(drinkStepper.value)
        updateTotal()
    }
    
    @IBAction func drinkButtonTapped(_ sender: UIButton) {
        guard let drinkName = sender.titleLabel?.text else { return }
        
        drinkInDrinkVC = drinks.first { $0.name == drinkName }
        countInDrinkVC = 1
        drinkStepper.value = 1
        updateTotal()
        nextButton.isEnabled = true
        drinkStepper.isEnabled = true
    }
    
    // Push values here into AdjustDrinksVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Drinks --> AdjustDrinkVC
        if let vc = segue.destination as? AdjustDrinkVC {
            vc.drinkInAdjustDrinkVC = drinkInDrinkVC
            vc.countInAdjustDrinkVC = countInDrinkVC
            vc.totalPriceInAdjustDrinkVC = totalPriceInDrinkVC
            vc.imageInAdjustDrinkVC = drinkInDrinkVC?.image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default
        nextButton.isEnabled = false
        drinkStepper.isEnabled = false
        totalLabel.text = "Total: $0.00"
    }
    
    // Helper Methods
    func updateTotal() {
        guard let drink = drinkInDrinkVC else { return }
        
        let total = drink.price(for: .medium) * Double(countInDrinkVC)
        totalLabel.text = "Total: $\(String(format: "%.2f", total)) (x\(countInDrinkVC))"
        
        // Update totalPriceInDrinkVC
        totalPriceInDrinkVC = total
    }
}
