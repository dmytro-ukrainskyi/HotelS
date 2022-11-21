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
        var alertBuilder = AlertBuilder(style: .alert)
            .title("Confirm log out")
            .addTextField(placeholder: "Email", keyboardType: .emailAddress)
            .addTextField(placeholder: "Password", keyboardType: .default)
            .addButton("Cancel", style: .cancel, completionHandler: nil)
        
        alertBuilder = alertBuilder
            .addButton("Log out", style: .default) {
            [weak self, unowned alertBuilder] _ in
            let email = alertBuilder.textFields![0].text!
            let password = alertBuilder.textFields![1].text!
            
            self?.checkCredentials(email: email, password: password)
        }
        
        let alertController = alertBuilder.build()
        
        present(alertController, animated: true)
    }
    
    func showFailedAuthAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error logging out")
            .message("Invalid email or password")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    //MARK: - Private methods
    private func setupNavigationBar() {
        navigationItem.title = Device.hotelName
        
        if !Device.isAdmin, navigationItem.rightBarButtonItems!.count > 1 {
            navigationItem.rightBarButtonItems?.removeLast()
        }
    }
    
}
