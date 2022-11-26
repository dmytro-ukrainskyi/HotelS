//
//  OrderViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import UIKit

extension OrderViewController {
    
    //MARK: - Public methods
    func saveOrder() {
        let order = createOrder()
        orderManager.save(order: order) { [weak self] in
            self?.roomManager.updateRoomsTotalBillWith(orderPrice: order.cost)
            self?.showSuccessAlert()
        }
    }
    
    //MARK: - Private methods
    private func createOrder() -> Order {
        let name = service.name
        let room = Device.roomNumber!
        let dateOrdered = Date()
        let datePicked = datePicker.date
        let comment = createOrderComment()
        let cost = service.price
        
        let order = Order(name: name, room: room, dateOrdered: dateOrdered, datePicked: datePicked, comment: comment, cost: cost, status: .new)
        
        return order
    }
    
    private func createOrderComment() -> String {
        if commentTextField.text == "" {
            return "No comment added"
        } else {
            return "Comment: \(commentTextField.text ?? "")"
        }
    }
    
    //MARK: - Navigation
    func goBackToServicesVC() {
        self.performSegue(withIdentifier: StoryboardConstants.unwindToServices, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.unwindToServices {
            let destinationVC = segue.destination as! ServicesCollectionViewController
            destinationVC.serviceCategory = service?.category
        }
    }
    
    
}
