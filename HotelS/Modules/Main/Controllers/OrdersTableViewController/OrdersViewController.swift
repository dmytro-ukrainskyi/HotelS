//
//  OrdersViewController.swift
//  HotelS
//
//  Created by dimas on 24.05.2022.
//

import UIKit

final class OrdersTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var filterPopUpButton: UIBarButtonItem!
    
    //MARK: - Public properties
    let ordersManager = OrdersManager()
    let roomsManager = RoomsManager()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadDefaultOrders()
    }
    
}
