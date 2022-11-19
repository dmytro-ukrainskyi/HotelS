//
//  CategoriesCollectionViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 04.06.2022.
//

import UIKit

extension CategoriesCollectionViewController {
    
    //MARK: - Public methods
    func checkCredentials(email: String, password: String) {
        loginManager.signInWith(email: email, password: password) { success in
            if success == true {
                self.logOut()
            } else {
                self.showFailedAuthAlert()
            }
        }
    }
    
    //MARK: - Private methods
    func logOut() {
        loginManager.logOut {
            self.openLoginVC()
        }
    }
    
    private func openLoginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: StoryboardConstants.loginViewControllerIdentifier)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginVC)
    }
    
}
