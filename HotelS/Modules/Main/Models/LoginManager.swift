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
    let roomManager = RoomsManager()

    //MARK: - Public methods
    //TODO:  Refactor completion handlers without using flags (?)
    func signInWith(email: String,
                    password: String,
                    completionHandler: @escaping (_ success: Bool) -> ()) {
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print("Error signing in: \(String(describing: error))")
                completionHandler(false)
            } else {
                self.downloadHotelName {
                    completionHandler(true)
                }
            }
        }
    }
    
    func loginAsGuest(roomNumber: Int, completionHandler: @escaping () -> ()) {
        let roomsRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .whereField(FStoreConstants.roomNumberField, isEqualTo: roomNumber)
        
        roomsRef.getDocuments { documents, error in
            if documents!.isEmpty {
                self.roomManager.saveRoom(roomNumber: roomNumber)
            }
        }
        
        Device.setRoomNumber(roomNumber)
        
        completionHandler()
    }
    
    func loginAsAdmin(completionHandler: @escaping () -> ()) {
        Device.setAdminStatus()
        
        completionHandler()
    }
    
    func registerWith(hotelName: String,
                      email: String,
                      password: String,
                      completionHandler: @escaping (_ success: Bool) -> ()) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error != nil {
                print("Error registering: \(String(describing: error))")
                completionHandler(false)
            } else {
                self.saveHotelWith(id: email, name: hotelName)
                
                completionHandler(true)
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
    
    private func downloadHotelName(completionHandler: @escaping () -> ()) {
        db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .getDocument { document, error in
                if error != nil {
                    print("Error loading hotel: \(String(describing: error))")
                } else {
                    let hotelName = document?.data()![FStoreConstants.hotelNameField] as! String
                    
                    Device.setHotelName(hotelName)
                    
                    completionHandler()
                }
            }
    }
    
}
