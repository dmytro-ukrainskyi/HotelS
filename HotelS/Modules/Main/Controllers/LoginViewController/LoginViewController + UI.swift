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
            .title("Create Hotel Account")
            .addTextField(placeholder: "Hotel name", keyboardType: .default)
            .addTextField(placeholder: "Email", keyboardType: .emailAddress)
            .addTextField(placeholder: "Password", keyboardType: .default)
            .addButton("Cancel", style: .cancel, completionHandler: nil)
        
        alertBuilder.textFields![2].isSecureTextEntry = true
        
        let nameTextField: UITextField? = alertBuilder.textFields?[0]
        let emailTextField: UITextField? = alertBuilder.textFields?[1]
        let passwordTextField: UITextField? = alertBuilder.textFields?[2]

        alertBuilder = alertBuilder
            .addButton("Create", style: .default) {
                let name = nameTextField!.text!
                let email = emailTextField!.text!
                let password = passwordTextField!.text!
                
                self.registerWith(hotelName: name, email: email, password: password)
            }
        
        let alertController = alertBuilder.build()
        
        present(alertController, animated: true)
    }
    
    func showSuccessfulRegistrationAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Hotel's Account Created")
            .message("You can proceed to login")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    //TODO: - Show more detailed info about errors
    func showFailedAuthAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error Signing In")
            .message("Invalid email or password")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    func showFailedRegistrationAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error Signing Up")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    func showInvalidRoomNumberAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Room Number Is Invalid")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
}
