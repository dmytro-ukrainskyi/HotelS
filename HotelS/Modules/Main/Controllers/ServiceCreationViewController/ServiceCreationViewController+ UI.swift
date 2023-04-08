//
//  ServiceViewController + UI.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import UIKit

extension ServiceCreationViewController {
    
    //MARK: - Public methods
    func setupUI() {
          hideKeyboardWhenTappedAround()
        categoryNameLabel.text = "Create service for category \"\(serviceCategory!.rawValue)\""
        
        if serviceToEdit != nil {
            setupServiceEditing()
            loadServiceImage()
        }
    }
    
    func setupServiceEditing() {
        categoryNameLabel.text = "Edit service"
        serviceNameTextField.text = serviceToEdit?.name
        serviceDescriptionTextView.text = serviceToEdit?.description
        servicePriceTextField.text = String(describing:serviceToEdit!.price)
        createButton.titleLabel?.text = "Save"
    }
    
    func showSuccessAlert() {
        let alertController = AlertBuilder(style: .alert)
            .message("Service successfully saved")
            .addButton("OK", style: .default) {
                self.goBackToServicesVC()
            }
            .build()
        
        present(alertController, animated: true)
    }
    
    func showMissingImageError() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error")
            .message("Service image is missing")
            .addButton("OK", style: .default)
            .build()
        
        present(alertController, animated: true)
    }
    
    func showImageSizeError() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error")
            .message("Image size is more than 1MB")
            .addButton("OK", style: .default)
            .build()
        
        present(alertController, animated: true)
    }
    
}
