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
        getDeviceRoomNumber()
    }
    
    static var isAdmin: Bool {
        isAdminDevice()
    }
    
    static var hotelName: String {
        getHotelName()
    }
    
    //MARK: - Private properties
    private static let defaults = UserDefaults.standard
    
    //MARK: - Public methods
    static func setAdminStatus() {
        defaults.set(true, forKey: UserDefaultsConstants.isAdmin)
        defaults.removeObject(forKey: UserDefaultsConstants.roomNumber)
    }
    
    static func setRoomNumber(_ roomNumber: Int) {
        defaults.set(false, forKey: UserDefaultsConstants.isAdmin)
        defaults.set(roomNumber, forKey: UserDefaultsConstants.roomNumber)
    }
    
    static func setHotelName(_ name: String) {
        defaults.set(name, forKey: UserDefaultsConstants.hotelName)
    }

        
    //MARK: - Private methods
    private static func getDeviceRoomNumber() -> Int {
        let deviceRoom = defaults.integer(forKey: UserDefaultsConstants.roomNumber)
        
        return deviceRoom
    }
    
    private static func isAdminDevice() -> Bool {
        let isAdmin = defaults.bool(forKey: UserDefaultsConstants.isAdmin)
        
        return isAdmin
    }
    
    private static func getHotelName() -> String {
        let hotelName = defaults.string(forKey: UserDefaultsConstants.hotelName)
        
        return hotelName ?? ""
    }
}
