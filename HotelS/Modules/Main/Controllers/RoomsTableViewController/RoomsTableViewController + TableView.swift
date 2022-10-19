//
//  RoomsTableViewController + TableView.swift
//  HotelS
//
//  Created by dimas on 06.06.2022.
//

import UIKit

extension RoomsTableViewController {
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomsManager.rooms.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardConstants.roomCellReuseIdentifier, for: indexPath) as! RoomCell
        
        let room = roomsManager.rooms[indexPath.row]
        
        cell.delegate = self
        cell.room = room
        cell.roomNumberLabel.text = "Room \(room.number)"
        cell.roomBillLabel.text = "Total bill: \(room.bill.currencyString)"
        
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(room: roomsManager.rooms[indexPath.row])
        }
    }
    
}
