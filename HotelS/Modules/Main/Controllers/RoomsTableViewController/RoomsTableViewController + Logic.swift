//
//  RoomsTableViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 06.06.2022.
//

import Foundation

extension RoomsTableViewController: RoomCellDelegate  {
    
    //MARK: - Public methods
    func checkOut(room: Room) {
        roomsManager.checkOut(room: room) {
            self.showSuccessfulCheckoutAlertFor(room: room)
        }
    }
    
    func loadRooms() {
        roomsManager.loadRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func delete(room: Room) {
        roomsManager.delete(room: room) {
            self.showSuccessfulDeleteAlertFor(room: room)
            self.loadRooms()
        }
    }

}
