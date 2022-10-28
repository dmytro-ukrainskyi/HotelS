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
    
    func showRegistrationAlert() {
        let alertBuilder = AlertBuilder(style: .alert)
            .title("Create hotel account")
            .addTextField(placeholder: "Hotel name", keyboardType: .default)
            .addTextField(placeholder: "Email", keyboardType: .emailAddress)
            .addTextField(placeholder: "Password", keyboardType: .default)
            .addButton("Cancel", style: .cancel, completionHandler: nil)
        
        let nameTextField = alertBuilder.alertController.textFields![0]
        let emailTextField = alertBuilder.alertController.textFields![1]
        let passwordTextField = alertBuilder.alertController.textFields![2]
        
        passwordTextField.isSecureTextEntry = true
        
        let alertController = alertBuilder
            .addButton("Create", style: .default) {_ in
                let name = nameTextField.text!
                let email = emailTextField.text!
                let password = passwordTextField.text!
                
                self.registerWith(hotelName: name, email: email, password: password)
                
            }
            .alertController
        
        present(alertController, animated: true)
    }
    
    func showSuccessfulRegistrationAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Hotel's account created")
            .message("You can proceed to login")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .alertController
        
        present(alertController, animated: true)
    }
    
    func showFailedAuthAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error signing in")
            .message("Invalid email or password")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .alertController
        
        present(alertController, animated: true)
    }
    
    func showFailedRegistrationAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error signing up")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .alertController
        
        present(alertController, animated: true)
    }
    
}
