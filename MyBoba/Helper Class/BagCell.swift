import UIKit

class BagCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // For Drink Items
    func configureDrink(with item: OrderItemDrinks) {
        // Top: "2x Mango Milk Tea"
        nameLabel.text = "\(item.quantity)x \(item.name) (\(item.size))"
        
        // Details with size, ice, sugar, topping
        var detailText = "\(item.ice), \(item.sugar)"
        
        if let topping = item.toppings {
            detailText += ", \(topping)"
        }
        
        detailsLabel.text = detailText
        
        // Price
        priceLabel.text = String(format: "$%.2f", item.price)
    }
    
    // For Snack Items
    func configureSnack(with item: OrderItemSnacks) {
        nameLabel.text = "\(item.quantity)x\(item.name)"
        detailsLabel.text = ""           // snacks may not have details
        priceLabel.text = String(format: "$%.2f", item.price)
    }
}
