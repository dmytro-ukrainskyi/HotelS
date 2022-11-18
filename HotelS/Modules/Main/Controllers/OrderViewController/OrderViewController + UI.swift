//
//  OrderViewController + UI.swift
//  HotelS
//
//  Created by dimas on 23.05.2022.
//

import UIKit

extension OrderViewController {
    
    //MARK: - Public methods
    func setupUI() {
        serviceNameLabel.text = service?.name
        serviceDescriptionLabel.text = service?.description
        servicePriceLabel.text = "\(service?.price.currencyString ?? "")"
        
        hideKeyboardWhenTappedAround()
        
        datePicker.minimumDate = Date()
    }
    
    func manageDatePicker() {
        if deliveryTimeSwitch.isOn {
            datePicker.isEnabled = true
        } else {
            datePicker.isEnabled = false
            datePicker.date = Date()
        }
    }
    
    func showSuccessAlert() {
        let alertController = AlertBuilder(style: .alert)
            .message("Order successfully saved")
            .addButton("OK", style: .default) {_ in
                self.goBackToServicesVC()
            }
            .alertController
        
        present(alertController, animated: true)
    }
}

