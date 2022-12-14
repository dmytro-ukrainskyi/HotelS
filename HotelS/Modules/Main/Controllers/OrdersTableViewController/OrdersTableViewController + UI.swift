//
//  OrdersTableViewController + UI.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import UIKit

extension OrdersTableViewController {
    
    //MARK: - Public methods
    func setupUI() {
        registerOrderCell()
        
        setupNavigationBarTitle()
        
        setupFilterPopUpButton()
    }
    
    
    func setupFilterPopUpButton() {
        guard Device.isAdmin else {
            navigationItem.rightBarButtonItem = nil
            return
        }
        
        filterPopUpButton.menu = UIMenu(children: [
            UIAction(title: "New & In Progress") { [unowned self] _ in
                self.loadDefaultOrders()
            },
            UIAction(title: "New") { [unowned self] _ in
                self.loadOrdersWith(status: .new)
            },
            UIAction(title: "In Progress") { [unowned self] _ in
                self.loadOrdersWith(status: .inProgress)
            },
            UIAction(title: "Completed") { [unowned self] _ in
                self.loadOrdersWith(status: .completed)
            },
            UIAction(title: "Paid") { [unowned self] _ in
                self.loadOrdersWith(status: .paid)
            }
        ])
    }
    
    func setupNavigationBarTitle() {
        navigationItem.largeTitleDisplayMode = .never

        if Device.isAdmin {
            title = .none
        } else {
            loadRoomBill()
        }
    }
    
    func show(_ alertController: UIAlertController,
              at indexPath: IndexPath) {
        if let popoverController = alertController.popoverPresentationController {
            let cell = tableView.cellForRow(at: indexPath)
            popoverController.sourceView = cell
            popoverController.sourceRect = cell?.bounds ?? CGRect(x: 0,
                                                                  y: 0,
                                                                  width: 50,
                                                                  height: 50)
        }
        
        present(alertController, animated: true)
    }
    
    func createAdminActionSheet(for order: Order) -> UIAlertController {
        var alertBuilder = AlertBuilder(style: .actionSheet)
            .message("Change order status")
        
        switch order.status {
        case .new:
            alertBuilder = alertBuilder.addButton("In progress", style: .default) {
                self.updateStatusFor(order: order, to: .inProgress)
            }
            
            alertBuilder = alertBuilder.addButton("Cancelled", style: .default) {
                self.updateStatusFor(order: order, to: .cancelled)
                self.roomsManager.refundFor(order: order) {}
            }
            
        case .inProgress:
            alertBuilder = alertBuilder.addButton("Completed", style: .default) {
                self.updateStatusFor(order: order, to: .completed)
            }
            
            alertBuilder = alertBuilder.addButton("Cancelled", style: .default) {
                self.updateStatusFor(order: order, to: .cancelled)
                self.roomsManager.refundFor(order: order) {}
            }
            
        default:
            break
        }
        
        let alertController = alertBuilder.build()
        
        return alertController
    }
    
    func createRoomActionSheet(for order: Order) -> UIAlertController {
        let alertController = AlertBuilder(style: .actionSheet)
            .message("Cancel order?")
            .addButton("Cancel", style: .destructive) {
                self.updateStatusFor(order: order, to: .cancelled)
                
                self.roomsManager.refundFor(order: order) {
                    self.tableView.reloadData()
                    self.loadRoomBill()
                }
            }
            .build()
        
        return alertController
    }
    
}
