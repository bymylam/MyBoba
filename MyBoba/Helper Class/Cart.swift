import UIKit

class Cart {
    static let shared = Cart()
    private init() {}
    
    var drinks: [OrderItemDrinks] = []
    var snacks: [OrderItemSnacks] = []

    func addDrink(_ item: OrderItemDrinks) {
        drinks.append(item)
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func addSnack(_ item: OrderItemSnacks) {
        snacks.append(item)
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func clear() {
        drinks.removeAll()
        snacks.removeAll()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
}

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}
