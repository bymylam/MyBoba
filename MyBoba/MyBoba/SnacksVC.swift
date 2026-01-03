import UIKit

class SnacksVC: UIViewController {
    
    // Snack Menu
    let snacks: [Snack] = [
        // Waffles
        Snack(image: UIImage(named: "waffle")!,
              name: "Waffles",
              basePrice: 4.75),
        // Croissant
        Snack(image: UIImage(named: "croissant")!,
              name: "Croissant",
              basePrice: 3.25),
    ]
    
    var snackInSnackVC: Snack?
    var countInSnackVC: Int?
    var totalPriceInSnackVC: Double?
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var snackStepper: UIStepper!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func snackButtonTapped(_ sender: UIButton) {
        guard let name = sender.titleLabel?.text else { return }
            
        // Find the snack by name
        snackInSnackVC = snacks.first { $0.name == name }
            
        // Reset count
        countInSnackVC = 1
        snackStepper.value = 1
        snackStepper.isEnabled = true
        addButton.isEnabled = true
        
        // Update Total Price
        updateTotalPrice()
    }
    
    @IBAction func snackStepperChanged(_ sender: UIStepper) {
        countInSnackVC = Int(snackStepper.value)
        updateTotalPrice()
    }
    
    // Capture the data - "Add to Bag" button
    @IBAction func addToBagTapped(_ sender: UIButton) {

        guard let snack = snackInSnackVC,
              let count = countInSnackVC else { return }

        let newItem = OrderItemSnacks(
            name: snack.name,
            price: snack.basePrice*Double(count),
            quantity: count
        )

        Cart.shared.addSnack(newItem)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default
        addButton.isEnabled = false
        snackStepper.isEnabled = false
        totalLabel.text = "Total: $0.00"
    }
    
    // Helper Methods
    func updateTotalPrice() {
        let price = snackInSnackVC?.basePrice ?? 0
        let count = countInSnackVC ?? 1
        let newTotal = price * Double(count)

        totalLabel.text = "Total: $\(String(format: "%.2f", newTotal))"
    }
}
