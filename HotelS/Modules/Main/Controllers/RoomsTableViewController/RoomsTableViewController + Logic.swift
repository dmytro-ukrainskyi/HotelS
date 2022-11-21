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
        roomsManager.checkOut(room: room) { [weak self] in
            self?.showSuccessfulCheckoutAlertFor(room: room)
        }
    }
    
    func loadRooms() {
        roomsManager.loadRooms { [weak self] in
                self?.tableView.reloadData()
        }
    }
    
    func delete(room: Room) {
        roomsManager.delete(room: room) { [weak self] in
            guard let self = self else { return }
            self.showSuccessfulDeleteAlertFor(room: room)
            self.loadRooms()
        }
    }

}
