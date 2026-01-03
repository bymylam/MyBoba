import UIKit

class OrderPlacedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var subtotal: Double = 0.0
    let taxRate = 0.8
    var total: Double = 0.0
    var orderNumber: Int = 0
    
    // Arrays with the features from a Struct
    var orderedDrinksPassed: [OrderItemDrinks] = []
    var orderedSnacksPassed: [OrderItemSnacks] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        // Clear cart
        Cart.shared.clear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        orderedDrinksPassed = Cart.shared.drinks
        orderedSnacksPassed = Cart.shared.snacks

        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartUpdated),
            name: .cartUpdated,
            object: nil
        )
        
        // Update the order number
        orderNumber = OrderManager.shared.orderNumber
        orderNumber += 1
        OrderManager.shared.orderNumber = orderNumber
        orderNumberLabel.text = String(orderNumber)
        
        // Drinks & Snacks Passed from BagVC
        orderedDrinksPassed = Cart.shared.drinks
        orderedSnacksPassed = Cart.shared.snacks
        tableView.reloadData()
        
        // Update the total price
        let tax = subtotal * taxRate
        subtotalLabel.text = String(format: "%.2f", subtotal)
        taxLabel.text = String(format: "%.2f", tax)
        totalLabel.text = String(format: "%.2f", total)
    }
    
    @objc func cartUpdated(_ notification: Notification) {
        orderedDrinksPassed = Cart.shared.drinks
        orderedSnacksPassed = Cart.shared.snacks
        tableView.reloadData()
    }
    
    // Table View Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? orderedDrinksPassed.count : orderedSnacksPassed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BagCell", for: indexPath) as! BagCell

        if indexPath.section == 0 {
            cell.configureDrink(with: orderedDrinksPassed[indexPath.row])
        } else {
            cell.configureSnack(with: orderedSnacksPassed[indexPath.row])
        }

        return cell
    }
    
}
