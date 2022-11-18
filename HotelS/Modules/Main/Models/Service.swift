//
//  Service.swift
//  HotelS
//
//  Created by dimas on 22.05.2022.
//

import Foundation
import UIKit

struct Service {
    
    //MARK: - Instance Properties
    var name: String
    var description: String
    var price: Double
    var category: Category
    var imageURL: URL?
    var documentID: String?
    
    //MARK: - Static Properties
    static let categories: [String] = Category.allCases.map({$0.rawValue})
    
    static let categoriesImages: [UIImage] = [
        UIImage(named: "housekeeping")!,
        UIImage(named: "room service")!,
        UIImage(named: "food delivery")!,
        UIImage(named: "drinks delivery")!,
        UIImage(named: "restaurant")!,
        UIImage(named: "vip")!,
        UIImage(named: "wellness")!,
        UIImage(named: "activities")!,
        UIImage(named: "personal service")!,
        UIImage(named: "delivery")!,
        UIImage(named: "other")!,
        UIImage(named: "room upgrade")!,
        UIImage(named: "check out")!
    ]
}

//MARK: - Service Category
extension Service {
    
    enum Category: String, CaseIterable {
        case houseKeeping = "Housekeeping"
        case roomService = "Room Service"
        case roomFood = "Food Delivery"
        case roomDrinks = "Drinks Delivery"
        case restaurant = "Restaurant"
        case vip = "VIP"
        case wellness = "Wellness"
        case activity = "Activities"
        case personal = "Personal Services"
        case delivery = "Delivery"
        case other = "Other"
        case roomUpgrade = "Room Upgrade"
        case checkOut = "Check Out"
    }
}
