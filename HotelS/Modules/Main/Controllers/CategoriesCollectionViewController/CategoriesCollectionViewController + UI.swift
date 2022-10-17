//
//  CategoriesCollectionViewController + UI.swift
//  HotelS
//
//  Created by dimas on 04.06.2022.
//

import UIKit

extension CategoriesCollectionViewController {
    
    //MARK: - Public methods
    func setupUI() {
        hideKeyboardWhenTappedAround()
        setupNavigationBar()
    }
    
    func showAuthorizationAlert() {
        let alertBuilder = AlertBuilder(style: .alert)
            .title("Confirm log out")
            .addTextField(placeholder: "Email", keyboardType: .emailAddress)
            .addTextField(placeholder: "Password", keyboardType: .default)
            .addButton("Cancel", style: .cancel, completionHandler: nil)
        
        //TODO: Update alert builder text field
        alertBuilder.alertController.textFields![1].isSecureTextEntry = true
        
        let alertController = alertBuilder
            .addButton("Log out", style: .default) {_ in
                let email = alertBuilder.alertController.textFields![0].text!
                let password = alertBuilder.alertController.textFields![1].text!
                
                self.checkCredentials(email: email, password: password)
            }
            .alertController
        
        present(alertController, animated: true)
    }
    
    func showFailedAuthAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error logging out")
            .message("Invalid email or password")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .alertController
        present(alertController, animated: true)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Device.hotelName

        if !Device.isAdmin, navigationItem.rightBarButtonItems!.count > 1 {
            navigationItem.rightBarButtonItems?.removeLast()
        }

    }
    
}
