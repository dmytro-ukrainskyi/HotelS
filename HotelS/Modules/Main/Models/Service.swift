//
//  Service.swift
//  HotelS
//
//  Created by dimas on 22.05.2022.
//

import Foundation
import UIKit

struct Service {
    
    //MARK: - Service properties
    var name: String
    var description: String
    var price: Double
    var category: Category
    var image: String?
    
    //MARK: - Categories
    static let categories: [String] = Category.allCases.map({$0.rawValue})
    
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
