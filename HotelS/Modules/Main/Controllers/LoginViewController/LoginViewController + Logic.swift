//
//  LoginViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 30.05.2022.
//

import UIKit

extension LoginViewController {
    
    //MARK: Public methods
    func signIn() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        loginManager.signInWith(email: email, password: password) { success in
            if success == true {
                self.login()
            } else {
                self.showFailedAuthAlert()
            }
        }
    }
    
    func registerWith(hotelName: String,
                      email: String,
                      password: String) {
        loginManager.registerWith(hotelName: hotelName,
                                  email: email,
                                  password: password) { success in
            if success == false {
                self.showFailedRegistrationAlert()
            } else {
                self.showSuccessfulRegistrationAlert()

                self.emailTextField.text = email
                self.passwordTextField.text = password
            }
        }
    }
    
    //MARK: Private methods
    private func login() {
        if adminSwitch.isOn {
            loginAsAdmin()
        } else {
            askRoomNumber()
        }
    }
    
    private func loginAsAdmin() {
        loginManager.loginAsAdmin {
            self.openCategoriesVC()
        }
    }
    
    private func askRoomNumber() {
        let alertBuilder = AlertBuilder(style: .alert)
            .message("Enter room number")
            .addTextField(placeholder: "Room number", keyboardType: .numberPad)
            .addButton("Cancel", style: .cancel, completionHandler: nil)
        
        let alertController = alertBuilder
            .addButton("Login", style: .default) {_ in
                let textField = alertBuilder.alertController.textFields?.first
                
                let roomNumberString = textField!.text
                
                if let roomNumber = Int(roomNumberString!) {
                    self.loginAsGuest(roomNumber: roomNumber)
                }
            }
            .alertController
        
        present(alertController, animated: true)
    }
    
    private func loginAsGuest(roomNumber: Int) {
        loginManager.loginAsGuest(roomNumber: roomNumber) {
            self.openCategoriesVC()
        }
    }
    
    private func openCategoriesVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(identifier: StoryboardConstants.navigationControllerIdentifier)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navigationController)
    }
    
}
