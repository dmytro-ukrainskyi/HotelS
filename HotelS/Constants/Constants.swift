//
//  Constants.swift
//  HotelS
//
//  Created by dimas on 24.05.2022.
//

import Foundation

enum DateFormatConstants {
    static let dateFormat = "MMM d, HH:mm"
    static let dateFormatterLocale = "en_US_POSIX"
}

enum StoryboardConstants {
    static let categoriesViewControllerIdentifier = "categoriesVC"
    static let loginViewControllerIdentifier = "loginVC"
    static let serviceCreationViewControllerIdentifier = "serviceCreationVC"
    static let navigationControllerIdentifier = "navigationController"

    static let categoryCellReuseIdentifier = "CategoryCell"
    static let serviceCellReuseIdentifier = "ServiceCell"
    static let orderCellReuseIdentifier = "OrderCell"
    static let roomCellReuseIdentifier = "RoomCell"
    
    static let toCategoriesSegueIdentifier = "toCategories"
    static let toServiceCreationSegueIdentifier = "toServiceCreation"
    static let toOrderSegueIdentifier = "toOrder"
    static let toOrdersSegueIdentifier = "toOrders"
    static let toServicesSegueIdentifier = "toServices"
    static let unwindToServices = "backToServices"
    
    static let orderCellNibName = "OrderCell"
    static let roomCellNibName = "RoomCell"
}

enum FStoreConstants {
    static let hotelsCollectionName = "hotels"
    static let hotelNameField = "name"
    
    static let ordersCollectionName = "orders"
    static let orderNameField = "name"
    static let orderIdField = "id"
    static let orderRoomField = "room"
    static let orderDateOrderedField = "dateOrdered"
    static let orderDatePickedField = "datePicked"
    static let orderCommentField = "comment"
    static let orderCostField = "cost"
    static let orderStatusField = "status"
    
    static let servicesCollectionName = "services"
    static let serviceNameField = "name"
    static let serviceDescriptionField = "description"
    static let servicePriceField = "price"
    static let serviceCategoryField = "category"
    static let serviceImageURLField = "imageURL"
    static let serviceDocumentIDField = "documentID"
    
    static let roomsCollectionName = "rooms"
    static let roomIdField = "id"
    static let roomBillField = "bill"
}

enum UserDefaultsConstants {
    static let roomNumber = "room"
    static let isAdmin = "isAdmin"
    static let hotelName = "hotelName"
}
