//
//  Orders.swift
//  HotelS
//
//  Created by dimas on 03.07.2022.
//

import Foundation
import Firebase

class OrdersManager {
    
    //MARK: - Public properties
    let db = Firestore.firestore()
    let roomManager = RoomsManager()
    
    var orders = [Order]()
    
    //MARK: - Public methods
    func save(order: Order, completionHandler: @escaping ()->()) {
        let orderRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
            .document()
        
        let documentID = orderRef.documentID
        
        orderRef.setData([
            FStoreConstants.orderNameField: order.name,
            FStoreConstants.orderCommentField: order.comment,
            FStoreConstants.orderRoomField: order.room,
            FStoreConstants.orderDateOrderedField: order.dateOrdered,
            FStoreConstants.orderDatePickedField: order.datePicked,
            FStoreConstants.orderCostField: order.cost,
            FStoreConstants.orderStatusField: order.status.rawValue,
            FStoreConstants.orderDocumentIDField: documentID
        ]) {error in
            if error != nil {
                print("Error saving order, \(error!)")
            }
            
            self.roomManager.updateRoomsTotalBillWith(orderPrice: order.cost)
            
            completionHandler()
        }
    }
    
    func loadDefaultOrders(completionHandler: @escaping ()->()) {
        loadOrdersFrom(query: createDefaultOrdersQuery(), completionHandler: completionHandler)
    }
    
    func loadOrdersWith(status: Order.Status,
                        completionHandler: @escaping ()->()) {
        let query = createQueryForOrdersWith(status: status)
        
        loadOrdersFrom(query: query, completionHandler: completionHandler)
    }
    
    func updateStatusFor(order: Order,
                         to status: Order.Status,
                         completionHandler: @escaping ()->()) {
        let orderRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
            .document(order.documentID!)
        
        orderRef.updateData([FStoreConstants.orderStatusField: status.rawValue])
        
        completionHandler()
    }
    
    //MARK:  Private methods
    private func loadOrdersFrom(query: Query, completionHandler: @escaping ()->()) {
        let ordersRef = query
        
        ordersRef.addSnapshotListener { querySnapshot, error in
            if error != nil {
                print("Error loading orders: \(String(describing: error))")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    self.orders = []
                    
                    for document in snapshotDocuments {
                        let order = self.loadOrder(from: document)
                        
                        self.orders.append(order)
                    }
                    
                    self.orders = self.orders.sorted(by: {$0.dateOrdered > $1.dateOrdered})
                    
                    completionHandler()
                }
            }
        }
    }
    
    private func loadOrder(from document: QueryDocumentSnapshot) -> Order {
        let data = document.data()
        let dateOrderedTimestamp = data[FStoreConstants.orderDateOrderedField] as! Timestamp
        let datePickedTimestamp = data[FStoreConstants.orderDatePickedField] as! Timestamp
        let statusString = data[FStoreConstants.orderStatusField] as! String
        
        let name = data[FStoreConstants.orderNameField] as! String
        let room =  data[FStoreConstants.orderRoomField] as! Int
        let dateOrdered = dateOrderedTimestamp.dateValue()
        let datePicked = datePickedTimestamp.dateValue()
        let comment = data[FStoreConstants.orderCommentField] as! String
        let cost = data[FStoreConstants.orderCostField] as! Double
        let status = Order.Status(rawValue: statusString)
        let documentID = data[FStoreConstants.orderDocumentIDField] as! String
        
        let order = Order(name: name, room: room, dateOrdered: dateOrdered, datePicked: datePicked, comment: comment, cost: cost, status: status!, documentID: documentID)
        
        return order
    }
    
    private func createDefaultOrdersQuery() -> Query {
        var ordersRef: Query
        
        if Device.isAdmin {
            let statusesToShow = [Order.Status.new.rawValue, Order.Status.inProgress.rawValue]
            
            ordersRef = db
                .collection(FStoreConstants.hotelsCollectionName)
                .document(Hotel.id)
                .collection(FStoreConstants.ordersCollectionName)
                .whereField(FStoreConstants.orderStatusField, in: statusesToShow)
            
        } else {
            let roomNumber = Device.roomNumber!
            
            ordersRef = db
                .collection(FStoreConstants.hotelsCollectionName)
                .document(Hotel.id)
                .collection(FStoreConstants.ordersCollectionName)
                .whereField(FStoreConstants.orderRoomField, isEqualTo: roomNumber)
                .whereField(FStoreConstants.orderStatusField, isNotEqualTo: Order.Status.paid.rawValue)
        }
        
        return ordersRef
    }
    
    private func createQueryForOrdersWith(status: Order.Status) -> Query {
        let ordersRef: Query

        ordersRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
            .whereField(FStoreConstants.orderStatusField, isEqualTo: status.rawValue)
        
        return ordersRef
    }
    
}
