//
//  Hotel.swift
//  HotelS
//
//  Created by dimas on 08.06.2022.
//

import Foundation
import Firebase

struct Hotel {
    
    static var id: String {
        (Auth.auth().currentUser?.email)!
    }
    
}
