//
//  LoginManager.swift
//  HotelS
//
//  Created by dimas on 08.10.2022.
//

import Foundation
import Firebase

class LoginManager {
    
    //MARK: - Public properties
    let db = Firestore.firestore()
    
    //MARK: - Private properties
    
    
    //MARK: - Public methods
    //TODO:  Refactor completion handlers without using flags
    func signInWith(email: String,
                    password: String,
                    completionHandler: @escaping (_ success: Bool) -> ()) {
        Firebase.Auth.auth().signIn(withEmail: email,
                                    password: password) { result, error in
            if error != nil {
                completionHandler(false)
            } else {
                self.db
                    .collection(FStoreConstants.hotelsCollectionName)
                    .document(email)
                    .getDocument { (document, error) in
                        if error != nil {
                            print("Error loading hotel: \(String(describing: error))")
                        } else {
                            let defaults = UserDefaults.standard
                            let hotelName = document?.data()![FStoreConstants.hotelNameField] as! String
                            
                            defaults.set(hotelName, forKey: UserDefaultsConstants.hotelName)
                            
                            completionHandler(true)
                        }
                    }
            }
        }
    }
    
    func loginAsGuest(roomNumber: Int, completionHandler: @escaping () -> ()) {
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName).document("\(roomNumber)")
        roomRef.getDocument { (document, error) in
            if let document = document, !document.exists {
                self.saveRoom(roomNumber: roomNumber)
            }
            
            Device.setRoomNumber(roomNumber)
            completionHandler()
        }
    }
    
    func registerWith(hotelName: String,
                      email: String,
                      password: String,
                      completionHandler: @escaping (_ success: Bool) -> ()) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email,
                                            password: password) { (_, error) in
            if error != nil {
                completionHandler(false)
            } else {
                self.saveHotelWith(id: email, name: hotelName)
            }
            
        }
    }
    
    func logOut(completionHandler: @escaping () -> ()) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
                completionHandler()
        } catch {
            print("Error signing out")
        }
    }
    
    //MARK: - Private methods
    private func saveHotelWith(id: String, name: String) {
        let hotelsRef = db.collection(FStoreConstants.hotelsCollectionName)
        
        hotelsRef.document(id).setData([
            FStoreConstants.hotelNameField: name
        ])
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

    
}
