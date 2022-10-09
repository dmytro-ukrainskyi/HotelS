//
//  CategoriesCollectionViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 04.06.2022.
//

import UIKit
import Firebase

extension CategoriesCollectionViewController {
    
    //MARK: - Public methods
    func askPassword() {
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
                
                FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if error != nil {
                        self.showFailedAuthAlert()
                        return
                    }
                    self.logOut()
                }
                
            }
            .alertController
        
        present(alertController, animated: true)
    }
    
    //MARK: - Private methods
    func logOut() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            openLoginVC()
        } catch {
            print("Error signing out")
        }
    }
    
    private func openLoginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: StoryboardConstants.loginViewControllerIdentifier)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginVC)
    }
    
}
