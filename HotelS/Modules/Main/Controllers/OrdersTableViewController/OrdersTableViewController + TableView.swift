//
//  OrdersTableViewController + TableView.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import UIKit

extension OrdersTableViewController {
    
    func registerOrderCell() {
        tableView.register(UINib(nibName: StoryboardConstants.orderCellNibName, bundle: nil),
                           forCellReuseIdentifier: StoryboardConstants.orderCellReuseIdentifier)
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return ordersManager.orders.count
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(235)
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: StoryboardConstants.orderCellReuseIdentifier,
            for: indexPath) as! OrderCell
        
        let order = ordersManager.orders[indexPath.row]
        
        cell.orderNameLabel?.text = order.name
        cell.roomIdLabel?.text = "\(order.room)"
        cell.dateOrderedLabel?.text = "Ordered: \(format(date: order.dateOrdered))"
        cell.datePickedLabel?.text = "Deliver at: \(format(date: order.datePicked))"
        cell.orderStatusLabel?.text = order.status.rawValue
        cell.orderCostLabel?.text = order.cost.currencyString
        cell.orderCommentLabel?.text = order.comment
        
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOrder = ordersManager.orders[indexPath.item]
        
        if !Device.isAdmin, selectedOrder.status == .new {
            let actionSheet = createRoomActionSheet(for: selectedOrder)
            show(actionSheet, at: indexPath)
        } else if Device.isAdmin,
                    selectedOrder.status == .new || selectedOrder.status == .inProgress {
            let actionSheet = createAdminActionSheet(for: selectedOrder)
            show(actionSheet, at: indexPath)
        }
    }
    
}
