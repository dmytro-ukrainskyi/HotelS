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
        orderManager.save(order: createOrder()) {
            self.showSuccessAlert()
        }
    }
    
    //MARK: - Private methods
    private func createOrder() -> Order {
        let comment: String
        
        if commentTextField.text == "" {
            comment = "No comment added"
        } else {
            comment = "Comment: \(commentTextField.text ?? "")"
        }
        
        let name = service?.name ?? ""
        let cost = service?.price ?? 0
        let room = Device.roomNumber!
        let dateOrdered = Date()
        let datePicked = datePicker.date
        
        let order = Order(name: name, room: room, dateOrdered: dateOrdered, datePicked: datePicked, comment: comment, cost: cost, status: .new)
        
        return order
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
