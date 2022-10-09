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
        navigationItem.largeTitleDisplayMode = .never
        
        registerOrderCell()
        
        setupNavigationBarTitle()
        
        setupFilterPopUpButton()
        
        if Device.isAdmin {
            setupFilterPopUpButton()
        } else {
            navigationItem.rightBarButtonItem = nil
            //getRoomBill()
        }
    }
    
    
    func setupFilterPopUpButton() {
        filterPopUpButton.menu = UIMenu(children: [
            UIAction(title: "New & In Progress") {_ in
                self.loadDefaultOrders()
            },
            UIAction(title: "New") {_ in
                self.loadOrdersWith(status: .new)
            },
            UIAction(title: "In Progress") {_ in
                self.loadOrdersWith(status: .inProgress)
            },
            UIAction(title: "Completed") {_ in
                self.loadOrdersWith(status: .completed)
            },
            UIAction(title: "Paid") {_ in
                self.loadOrdersWith(status: .paid)
            }
        ])
    }
    
    func setupNavigationBarTitle() {
        if Device.isAdmin {
            title = .none
        } else {
            //getRoomBill()
        }
    }
    
    func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: DateFormatConstants.dateFormatterLocale)
        dateFormatter.dateFormat = DateFormatConstants.dateFormat
        return dateFormatter.string(from: date)
    }
    
    func show(_ alertController: UIAlertController, at indexPath: IndexPath) {
        if let popoverController = alertController.popoverPresentationController {
            let cell = tableView.cellForRow(at: indexPath)
            popoverController.sourceView = cell
            popoverController.sourceRect = cell?.bounds ?? CGRect(x: 0, y: 0, width: 50, height: 50)
        }
        
        present(alertController, animated: true)
    }
    
    func createAdminActionSheet(for order: Order) -> UIAlertController {
        var alertBuilder = AlertBuilder(style: .actionSheet)
            .message("Change order status")
        
        switch order.status {
        case .new:
            alertBuilder = alertBuilder.addButton("In progress", style: .default)
            { _ in
                self.updateStatusFor(order: order, to: .inProgress)
            }
            alertBuilder = alertBuilder.addButton("Cancelled", style: .default)
            { _ in
                self.updateStatusFor(order: order, to: .cancelled)
            }
        case .inProgress:
            alertBuilder = alertBuilder.addButton("Completed", style: .default)
            { _ in
                self.updateStatusFor(order: order, to: .completed)
            }
            alertBuilder = alertBuilder.addButton("Cancelled", style: .default)
            { _ in
                self.updateStatusFor(order: order, to: .cancelled)
            }
        default:
            break
        }
        
        let alertController = alertBuilder.alertController
        
        return alertController
    }
    
    func createRoomActionSheet(for order: Order) -> UIAlertController {
        let alertController = AlertBuilder(style: .actionSheet)
            .message("Cancel order?")
            .addButton("Cancel", style: .destructive) { _ in
                self.updateStatusFor(order: order, to: .cancelled)
                self.roomsManager.refundFor(order: order) {
                    self.tableView.reloadData()
                }
            }
            .alertController
        
        return alertController
    }
    
}
