//
//  Constants.swift
//  HotelS
//
//  Created by dimas on 24.05.2022.
//

import Foundation

enum DateFormatConstants {
    
    static let localeIdentifier = "MMM d, HH:mm"
    
}

enum CurrencyFormatConstants {
    
    static let currencyCode = "USD"
    static let localeIdentifier = "en_US"
    
}

enum StoryboardConstants {
    
    //MARK:  Storyboard Identifiers
    static let mainStoryboard = "Main"
    
    //MARK:  ViewController Identifiers
    static let categoriesViewControllerIdentifier = "categoriesVC"
    static let loginViewControllerIdentifier = "loginVC"
    static let serviceCreationViewControllerIdentifier = "serviceCreationVC"
    static let navigationControllerIdentifier = "navigationController"

    //MARK:  Cell Reuse Identifiers
    static let categoryCellReuseIdentifier = "CategoryCell"
    static let serviceCellReuseIdentifier = "ServiceCell"
    static let orderCellReuseIdentifier = "OrderCell"
    static let roomCellReuseIdentifier = "RoomCell"
    
    //MARK: Segue Identifiers
    static let toCategoriesSegueIdentifier = "toCategories"
    static let toServiceCreationSegueIdentifier = "toServiceCreation"
    static let toOrderSegueIdentifier = "toOrder"
    static let toOrdersSegueIdentifier = "toOrders"
    static let toServicesSegueIdentifier = "toServices"
    static let unwindToServices = "backToServices"
    
    //MARK: Cell Nib Names
    static let orderCellNibName = "OrderCell"
    static let roomCellNibName = "RoomCell"
    
}

enum FStoreConstants {
    
    //MARK: Hotels
    static let hotelsCollectionName = "hotels"
    static let hotelNameField = "name"
    
    //MARK: Orders
    static let ordersCollectionName = "orders"
    static let orderNameField = "name"
    static let orderRoomField = "room"
    static let orderDateOrderedField = "dateOrdered"
    static let orderDatePickedField = "datePicked"
    static let orderCommentField = "comment"
    static let orderCostField = "cost"
    static let orderStatusField = "status"
    static let orderDocumentIDField = "documentID"
    
    //MARK: Services
    static let servicesCollectionName = "services"
    static let serviceNameField = "name"
    static let serviceDescriptionField = "description"
    static let servicePriceField = "price"
    static let serviceCategoryField = "category"
    static let serviceImageURLField = "imageURL"
    static let serviceDocumentIDField = "documentID"
    
    //MARK: Rooms
    static let roomsCollectionName = "rooms"
    static let roomNumberField = "id"
    static let roomBillField = "bill"
    
}

enum UserDefaultsConstants {
    
    static let roomNumber = "room"
    static let isAdmin = "isAdmin"
    static let hotelName = "hotelName"
    
}
