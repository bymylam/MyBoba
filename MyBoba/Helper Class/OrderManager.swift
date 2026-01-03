import Foundation

class OrderManager {
    static let shared = OrderManager()

    var orderNumber: Int = 0

    private init() {}
}
