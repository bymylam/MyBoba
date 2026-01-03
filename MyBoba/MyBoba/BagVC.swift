import UIKit

class BagVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var orderedDrinks: [OrderItemDrinks] = []
    var orderedSnacks: [OrderItemSnacks] = []
    let taxRate = 0.08
    
    var subtotal: Double = 0.0
    var total: Double = 0.0

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var clearAllOrdersButton: UIBarButtonItem!
    @IBOutlet weak var confirmOrderButton: UIButton!
    
    // Clear everything from Cart
    @IBAction func clearAllOrdersTapped(_ sender: UIBarButtonItem) {
//        Cart.shared.clear()
        
        // Alert if the user really wants to delete everything
        let alert = UIAlertController(title: "Clear All Orders?", message: "Are you sure you want to remove all items from your bag?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { _ in
            Cart.shared.clear()
        })
        
        present(alert, animated: true)
    }
    
    // Unwind to Bag back after Order Placed
    @IBAction func unwindToBag(_ segue: UIStoryboardSegue) { 
        Cart.shared.clear()
    }
    
    // Push data to OrderPlacedVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // BagVC --> OrderPlacedVC
        if let vc = segue.destination as? OrderPlacedVC {
            vc.subtotal = subtotal
            vc.total = total
            
            // For Table View Part
            vc.orderedDrinksPassed = orderedDrinks
            vc.orderedSnacksPassed = orderedSnacks
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        orderedDrinks = Cart.shared.drinks
        orderedSnacks = Cart.shared.snacks

        tableView.reloadData()
        updateTotals()
        
        // Enable button only if there are items
        clearAllOrdersButton.isEnabled = !Cart.shared.drinks.isEmpty || !Cart.shared.snacks.isEmpty
        
        // Enable "Confirm" button only if there are items
        confirmOrderButton.isEnabled = !Cart.shared.drinks.isEmpty || !Cart.shared.snacks.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartUpdated),
            name: .cartUpdated,
            object: nil
        )
        
        // initial load
        orderedDrinks = Cart.shared.drinks
        orderedSnacks = Cart.shared.snacks
        tableView.reloadData()
        updateTotals()
    }

    @objc func cartUpdated(_ notification: Notification) {
        orderedDrinks = Cart.shared.drinks
        orderedSnacks = Cart.shared.snacks
        tableView.reloadData()
        updateTotals()
        
        // Enable "Clear" button only if there are items
        clearAllOrdersButton.isEnabled = !orderedDrinks.isEmpty || !orderedSnacks.isEmpty
        
        // Enable "Confirm" button only if there are items
        confirmOrderButton.isEnabled = !orderedDrinks.isEmpty || !orderedSnacks.isEmpty
    }

    // Table View Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // section 0 = drinks, section 1 = snacks
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? orderedDrinks.count : orderedSnacks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "BagCell", for: indexPath) as! BagCell

        if indexPath.section == 0 {
            cell.configureDrink(with: orderedDrinks[indexPath.row])
        } else {
            cell.configureSnack(with: orderedSnacks[indexPath.row])
        }

        return cell
    }

    func updateTotals() {
        let drinkTotal = orderedDrinks.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        let snackTotal = orderedSnacks.reduce(0) { $0 + ($1.price) }

        subtotal = drinkTotal + snackTotal
        let tax = subtotal * taxRate
        total = subtotal + tax

        subtotalLabel.text = String(format: "%.2f", subtotal)
        taxLabel.text = String(format: "%.2f", tax)
        totalLabel.text = String(format: "%.2f", total)
    }
}
