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
    
    static var roomId: Int {
        getDeviceRoomId()
    }
    
    static var isAdmin: Bool {
        isAdminDevice()
    }
    
    static var hotelName: String {
        getHotelName()
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
