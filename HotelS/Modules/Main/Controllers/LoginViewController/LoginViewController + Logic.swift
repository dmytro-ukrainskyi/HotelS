//
//  LoginViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 30.05.2022.
//

import UIKit

extension LoginViewController {
    
    //MARK: - Public methods
    func signIn() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        loginManager
            .signInWith(email: email, password: password) { [weak self] success in
                if success {
                    self?.login()
                } else {
                    self?.showFailedAuthAlert()
                }
            }
    }
    
    func registerWith(hotelName: String,
                      email: String,
                      password: String) {
        loginManager.registerWith(hotelName: hotelName,
                                  email: email,
                                  password: password) { [weak self] success in
            guard let self = self else { return }
            
            if success {
                self.showSuccessfulRegistrationAlert()
                
                self.emailTextField.text = email
                self.passwordTextField.text = password
            } else {
                self.showFailedRegistrationAlert()
            }
        }
    }
    
    //MARK: - Private methods
    private func login() {
        if adminSwitch.isOn {
            loginAsAdmin()
        } else {
            askRoomNumber()
        }
    }
    
    private func loginAsAdmin() {
        loginManager.loginAsAdmin { [weak self] in
            self?.openCategoriesVC()
        }
    }
    
    private func askRoomNumber() {
        var alertBuilder = AlertBuilder(style: .alert)
            .message("Enter room number")
            .addTextField(placeholder: "Room number", keyboardType: .numberPad)
            .addButton("Cancel", style: .cancel, completionHandler: nil)
        
        let roomNumberTextField: UITextField? = alertBuilder.textFields![0]
        
        alertBuilder = alertBuilder
            .addButton("Login", style: .default) {
                let roomNumberString = roomNumberTextField?.text
                
                guard let roomNumber = Int(roomNumberString!) else {
                    self.showInvalidRoomNumberAlert()
                    return
                }
                
                self.loginAsGuest(roomNumber: roomNumber)
            }
        
        let alertController = alertBuilder.build()
        
        present(alertController, animated: true)
    }
    
    private func loginAsGuest(roomNumber: Int) {
        loginManager.loginAsGuest(roomNumber: roomNumber) { [weak self] in
            self?.openCategoriesVC()
        }
    }
    
    private func openCategoriesVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(identifier: StoryboardConstants.navigationControllerIdentifier)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navigationController)
    }
    
}
