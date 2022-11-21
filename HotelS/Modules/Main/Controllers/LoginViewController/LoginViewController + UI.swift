//
//  LoginViewController + UI.swift
//  HotelS
//
//  Created by dimas on 30.05.2022.
//

import UIKit

extension LoginViewController {
    
    func setupUI() {
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Alerts
    func showRegistrationAlert() {
        var alertBuilder = AlertBuilder(style: .alert)
            .title("Create hotel account")
            .addTextField(placeholder: "Hotel name", keyboardType: .default)
            .addTextField(placeholder: "Email", keyboardType: .emailAddress)
            .addTextField(placeholder: "Password", keyboardType: .default)
            .addButton("Cancel", style: .cancel, completionHandler: nil)
        
        alertBuilder = alertBuilder
            .addButton("Create", style: .default) {
                [weak self, unowned alertBuilder] _ in
                let name = alertBuilder.textFields![0].text!
                let email = alertBuilder.textFields![1].text!
                let password = alertBuilder.textFields![2].text!
                
                print(name, email, password)
                self?.registerWith(hotelName: name, email: email, password: password)
            }
        
        alertBuilder.textFields![2].isSecureTextEntry = true
        
        let alertController = alertBuilder.build()
        
        present(alertController, animated: true)
    }
    
    func showSuccessfulRegistrationAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Hotel's account created")
            .message("You can proceed to login")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    //TODO: - Show more detailed info about errors
    func showFailedAuthAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error signing in")
            .message("Invalid email or password")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    func showFailedRegistrationAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error signing up")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    func showInvalidRoomNumberAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Room number is invalid")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
}
