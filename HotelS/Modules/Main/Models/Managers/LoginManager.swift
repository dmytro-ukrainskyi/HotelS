//
//  LoginManager.swift
//  HotelS
//
//  Created by dimas on 08.10.2022.
//

import Foundation
import Firebase

final class LoginManager {
    
    //MARK: - Private properties
    private let firestore = Firestore.firestore()
    private let auth = Firebase.Auth.auth()
    private let roomManager = RoomsManager()
    
    //MARK: - Public methods
    func signInWith(email: String,
                    password: String,
                    completionHandler: @escaping (_ success: Bool) -> ()) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("Error signing in: \(error)")
                completionHandler(false)
                return
            }
            
            self.downloadHotelName {
                completionHandler(true)
            }
        }
    }
    // TODO: - Add error handling to callback
    func loginAsGuest(roomNumber: Int, completionHandler: @escaping () -> ()) {
        let roomsRef = firestore
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .whereField(FStoreConstants.roomNumberField, isEqualTo: roomNumber)
        
        roomsRef.getDocuments { [weak self] querySnapshot, error in
            if let error = error {
                print("Error getting rooms: \(error)")
                return
            }
            
            if let querySnapshot = querySnapshot, querySnapshot.isEmpty {
                self?.roomManager.saveRoom(roomNumber: roomNumber)
            }
            
            Device.setRoomNumber(roomNumber)
            
            completionHandler()
        }
    }
    
    func loginAsAdmin(completionHandler: @escaping () -> ()) {
        Device.setAdminStatus()
        
        completionHandler()
    }
    
    func registerWith(hotelName: String,
                      email: String,
                      password: String,
                      completionHandler: @escaping (_ success: Bool) -> ()) {
        auth.createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                print("Error registering: \(error)")
                completionHandler(false)
                return
            }
            
            self.saveHotelWith(id: email, name: hotelName)
                
            completionHandler(true)
        }
    }
    
    func logOut(completionHandler: @escaping () -> ()) {
        do {
            try auth.signOut()
            
            completionHandler()
        } catch {
            print("Error signing out")
        }
    }
    
    //MARK: - Private methods
    private func saveHotelWith(id: String, name: String) {
        let hotelsRef = firestore.collection(FStoreConstants.hotelsCollectionName)
        
        hotelsRef.document(id).setData([
            FStoreConstants.hotelNameField: name
        ])
    }
    
    private func downloadHotelName(completionHandler: @escaping () -> ()) {
        firestore
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .getDocument { document, error in
                if let error = error {
                    print("Error loading hotel: \(error)")
                    return
                }
                
                if let data = document?.data() {
                    let hotelName = data[FStoreConstants.hotelNameField] as! String
                        
                    Device.setHotelName(hotelName)
                        
                    completionHandler()
                }
            }
    }
    
}
