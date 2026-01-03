import Foundation
import UIKit

enum DrinkSize: String, CaseIterable {
    case hot = "H"
    case medium = "M"
    case large = "L"
    
    var sizePriceModifier: Double {
        switch self {
        case .hot, .medium: return 0.0
        case .large: return 1.0
        }
    }
}

enum ToppingOption: String, CaseIterable {
    case pearls = "Pearls"
    case pudding = "Pudding"
    case coconutJelly = "Coconut Jelly"
    case redBeans = "Red Beans"
    
    var toppingPriceModifier: Double { return 0.75 }
}

struct Drink {
    let image: UIImage
    let name: String
    let basePrice: Double
    let availableSizes: [DrinkSize]   // e.g., ["H": 0, "M": 0, "L": 1.00]
    let sugarLevels: [Int]            // e.g., ["0", "30", "60", "100", "120"]
    let iceLevels: [Int]               // e.g., ["No Ice": 0, "Less Ice": 50, "Regular Ice": 100, "More Ice": 120]
    let toppings: [ToppingOption]    // e.g., ["Boba": 0.75, "Pudding": 0.75]
    
    func price(for size: DrinkSize, selectedToppings: [ToppingOption] = []) -> Double {
        // Initialize toppings price
        var toppingsPrice = 0.0
        
        // Sum up the price of all selected toppings
        for topping in selectedToppings {
            toppingsPrice += topping.toppingPriceModifier
        }
        
        // Total = base price + size modifier + toppings
        return basePrice + size.sizePriceModifier + toppingsPrice
    }
    
    // Only return ice levels if the drink size is cold
    func availableIceLevels(for size: DrinkSize) -> [Int] {
        switch size {
        case .hot:
            return []
        case .medium, .large:
            return iceLevels
        }
    }
}
