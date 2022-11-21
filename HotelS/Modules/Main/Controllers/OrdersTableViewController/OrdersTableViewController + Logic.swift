//
//  OrdersTableViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import Foundation

extension OrdersTableViewController {
    
    //MARK: - Public methods
    func loadRoomBill() {
        roomsManager.getRoomBill() { [weak self] bill in
            self?.title = "Room: \(Device.roomNumber!)   Total bill: $\(bill)"
        }
    }
    
    func loadDefaultOrders() {
        ordersManager.loadDefaultOrders { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func loadOrdersWith(status: Order.Status) {
        ordersManager.loadOrdersWith(status: status) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func updateStatusFor(order: Order, to status: Order.Status) {
        ordersManager.updateStatusFor(order: order, to: status) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}
