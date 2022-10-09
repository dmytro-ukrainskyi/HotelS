//
//  RoomsTableViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 06.06.2022.
//

import Foundation

extension RoomsTableViewController: RoomCellDelegate  {
    
    func checkOut(room: Room) {
        roomsManager.checkOut(room: room) {
            self.showSuccessfulCheckoutAlertFor(room: room)
        }
    }
    
    func loadRooms() {
        roomsManager.loadRooms {
            self.tableView.reloadData()
        }
    }
    
    func delete(room: Room) {
        roomsManager.delete(room: room) {
            self.showSuccessfulDeleteAlertFor(room: room)
            self.loadRooms()
        }
    }

}
