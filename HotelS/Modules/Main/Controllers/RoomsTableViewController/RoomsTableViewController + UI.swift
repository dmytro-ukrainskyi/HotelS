//
//  RoomsTableViewController + UI.swift
//  HotelS
//
//  Created by dimas on 06.06.2022.
//

import Foundation

extension RoomsTableViewController {
    
    func showSuccessfulCheckoutAlertFor(room: Room) {
        let alertController = AlertBuilder(style: .alert)
            .message("Room \(room.id) has been checked out")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .alertController
        
        present(alertController, animated: true)
    }
    
    func showSuccessfulDeleteAlertFor(room: Room) {
        let alertController = AlertBuilder(style: .alert)
            .message("Room \(room.id) has been deleted")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .alertController
        
        present(alertController, animated: true)
    }
    
    
}
