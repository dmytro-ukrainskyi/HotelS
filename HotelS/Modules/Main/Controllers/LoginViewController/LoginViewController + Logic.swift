//
//  LoginViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 30.05.2022.
//

import UIKit
import Firebase

extension LoginViewController {
    
    //MARK: - Login
    
    //MARK: Public methods
    func signIn() {
        let email = emailTextField.text
        let password = passwordTextField.text
        Firebase.Auth.auth().signIn(withEmail: email!, password: password!) { result, error in
            if error != nil {
                self.showFailedAuthAlert()
            } else {
                self.db.collection(FStoreConstants.hotelsCollectionName).document(email!).getDocument { (document, error) in
                    if error != nil {
                        print("Error loading hotel: \(String(describing: error))")
                    } else {
                        let defaults = UserDefaults.standard
                        let hotelName = document?.data()![FStoreConstants.hotelNameField] as! String
                        defaults.set(hotelName, forKey: UserDefaultsConstants.hotelName)
                        self.login()
                    }
                }
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
        setAdminStatus()
        openCategoriesVC()
    }
    
    private func setAdminStatus() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: UserDefaultsConstants.isAdmin)
        defaults.removeObject(forKey: UserDefaultsConstants.roomNumber)
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
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName).document("\(roomNumber)")
        roomRef.getDocument { (document, error) in
            if let document = document, !document.exists {
                self.saveRoom(roomNumber: roomNumber)
            }
            
            self.setDeviceRoomNumber(roomNumber: roomNumber)
            self.openCategoriesVC()
        }
    }
    
    private func saveRoom(roomNumber: Int) {
        let roomsRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
        
        roomsRef.document("\(roomNumber)").setData([
            FStoreConstants.roomIdField: roomNumber,
            FStoreConstants.roomBillField: 0
        ])
    }
    
    private func setDeviceRoomNumber(roomNumber: Int) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: UserDefaultsConstants.isAdmin)
        defaults.set(roomNumber, forKey: UserDefaultsConstants.roomNumber)
    }
    
    //MARK: - Registration
    
    //MARK:  Public methods
    func showRegistrationAlert() {
        let alertBuilder = AlertBuilder(style: .alert)
            .title("Create hotel account")
            .addTextField(placeholder: "Hotel name", keyboardType: .default)
            .addTextField(placeholder: "Email", keyboardType: .emailAddress)
            .addTextField(placeholder: "Password", keyboardType: .default)
            .addButton("Cancel", style: .cancel, completionHandler: nil)
        
        //TODO: Update alert builder text field (?)
        alertBuilder.alertController.textFields![2].isSecureTextEntry = true
        
        let alertController = alertBuilder
            .addButton("Create", style: .default) {_ in
                let name = alertBuilder.alertController.textFields![0].text!
                let email = alertBuilder.alertController.textFields![1].text!
                let password = alertBuilder.alertController.textFields![2].text!
                
                self.registerWith(hotelName: name, email: email, password: password)
                
            }
            .alertController
        
        present(alertController, animated: true)
    }
    
    //MARK: Private methods
    private func registerWith(hotelName: String, email: String, password: String) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error != nil {
                self.showFailedRegistrationAlert()
            } else {
                self.saveHotelWith(id: email, name: hotelName)
            }
            
        }
    }
    
    private func saveHotelWith(id: String, name: String) {
        let hotelsRef = db.collection(FStoreConstants.hotelsCollectionName)
        
        hotelsRef.document(id).setData([
            FStoreConstants.hotelNameField: name
        ])
    }
    
    //MARK: - Navigation
    private func openCategoriesVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(identifier: StoryboardConstants.navigationControllerIdentifier)

           (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navigationController)
    }
    
}
