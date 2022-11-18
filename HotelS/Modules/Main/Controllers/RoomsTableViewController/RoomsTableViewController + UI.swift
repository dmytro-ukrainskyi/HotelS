//
//  RoomsTableViewController + UI.swift
//  HotelS
//
//  Created by dimas on 06.06.2022.
//

import Foundation

extension RoomsTableViewController {
    
    //MARK: - Public methods
    func showSuccessfulCheckoutAlertFor(room: Room) {
        let alertController = AlertBuilder(style: .alert)
            .message("Room \(room.number) has been checked out")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .alertController
        
        present(alertController, animated: true)
    }
    
    func showSuccessfulDeleteAlertFor(room: Room) {
        let alertController = AlertBuilder(style: .alert)
            .message("Room \(room.number) has been deleted")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .alertController
        
        present(alertController, animated: true)
    }
}
