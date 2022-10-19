//
//  Device.swift
//  HotelS
//
//  Created by dimas on 01.06.2022.
//

import Foundation
import Firebase

struct Device {
    
    //MARK: - Public properties
    static var roomNumber: Int? {
        getDeviceRoomId()
    }
    
    static var isAdmin: Bool {
        isAdminDevice()
    }
    
    static var hotelName: String {
        getHotelName()
    }
    
    //MARK: - Private properties
    private static let db = Firestore.firestore()
    
    //MARK: - Public methods
    static func setAdminStatus() {
        let defaults = UserDefaults.standard
        
        defaults.set(true, forKey: UserDefaultsConstants.isAdmin)
        defaults.removeObject(forKey: UserDefaultsConstants.roomNumber)
    }
    
    static func setRoomNumber(_ roomNumber: Int) {
        let defaults = UserDefaults.standard
        
        defaults.set(false, forKey: UserDefaultsConstants.isAdmin)
        defaults.set(roomNumber, forKey: UserDefaultsConstants.roomNumber)
    }
    
    static func setHotelName(_ name: String) {
        let defaults = UserDefaults.standard
        
        defaults.set(name, forKey: UserDefaultsConstants.hotelName)
    }

        
    //MARK: - Private methods
    private static func getDeviceRoomId() -> Int {
        let deviceRoom = UserDefaults.standard.integer(forKey: UserDefaultsConstants.roomNumber)
        
        return deviceRoom
    }
    
    private static func isAdminDevice() -> Bool {
        let isAdmin = UserDefaults.standard.bool(forKey: UserDefaultsConstants.isAdmin)
        
        return isAdmin
    }
    
    private static func getHotelName() -> String {
        let hotelName = UserDefaults.standard.string(forKey: UserDefaultsConstants.hotelName)
        
        return hotelName ?? ""
    }
    
}
