//
//  RoomsTableViewController + UI.swift
//  HotelS
//
//  Created by dimas on 06.06.2022.
//

import Foundation
import UIKit

extension RoomsTableViewController {
    
    //MARK: - Public methods
    func showCheckOutConfirmationAlertFor(room: Room) {
        let alertController = AlertBuilder(style: .alert)
            .title("Check Out Room \(room.number)")
            .message("This will delete it's incomplete orders, change \"COMPLETED\" statuses to \"PAID\" and reset room's bill.")
            .addButton("Check Out", style: .destructive) { [weak self] in
                self?.checkOut(room: room)
            }
            .addButton("Cancel", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    func showDeleteConfirmationAlertFor(room: Room) {
        let alertController = AlertBuilder(style: .alert)
            .title("Delete Room \(room.number)")
            .message("This will also delete it's incomplete orders.")
            .addButton("Delete", style: .destructive) { [weak self] in
                self?.delete(room: room)
            }
            .addButton("Cancel", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    func showSuccessfulCheckoutAlertFor(room: Room) {
        let alertController = AlertBuilder(style: .alert)
            .message("Room \(room.number) has been checked out.")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    func showSuccessfulDeleteAlertFor(room: Room) {
        let alertController = AlertBuilder(style: .alert)
            .message("Room \(room.number) has been deleted.")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .build()
        
        present(alertController, animated: true)
    }
    
    
}
