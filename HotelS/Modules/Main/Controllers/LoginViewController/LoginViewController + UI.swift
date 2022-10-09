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
