//
//  OrderViewController.swift
//  HotelS
//
//  Created by dimas on 23.05.2022.
//

import UIKit

final class OrderViewController: UIViewController {
    
    //MARK: - Public properties
    let orderManager = OrdersManager()
    
    var service: Service?
        
    //MARK: - IBOutlets
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    @IBOutlet weak var serviceDescriptionLabel: UILabel!
    
    @IBOutlet weak var servicePriceLabel: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var deliveryTimeSwitch: UISwitch!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        saveOrder()
    }

    @IBAction func deliveryTimeSwitchTapped(_ sender: UISwitch) {
        manageDatePicker()
    }
    
}
