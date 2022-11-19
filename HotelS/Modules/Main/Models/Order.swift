//
//  Order.swift
//  HotelS
//
//  Created by dimas on 22.05.2022.
//

import Foundation

struct Order {
    
    var name: String
    var room: Int
    var dateOrdered: Date
    var datePicked: Date
    var comment: String
    var cost: Double
    var status: Status
    var documentID: String?
    
    //MARK: - Order status
    enum Status: String {
        case new = "New"
        case inProgress = "In progress"
        case completed = "Completed"
        case paid = "Paid"
        case cancelled = "Cancelled"
    }
    
}
