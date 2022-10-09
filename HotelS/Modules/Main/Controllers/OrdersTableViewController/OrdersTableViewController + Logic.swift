//
//  OrdersTableViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import Foundation

extension OrdersTableViewController {
    
    //MARK: - Public methods
    func loadDefaultOrders() {
        ordersManager.loadDefaultOrders {
            self.tableView.reloadData()
        }
    }
    
    func loadOrdersWith(status: Order.Status) {
        ordersManager.loadOrdersWith(status: status) {
            self.tableView.reloadData()
        }
    }
    
    func updateStatusFor(order: Order, to status: Order.Status) {
        ordersManager.updateStatusFor(order: order, to: status) {
            self.tableView.reloadData()
        }
    }
    
}
