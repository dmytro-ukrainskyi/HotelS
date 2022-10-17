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
    var orders = [Order]()
    
    //MARK: - Public methods
    //TODO: - REFACTOR ORDER NUMBER
    func register(order: Order, completionHandler: @escaping ()->()) {
        let lastOrderQuery = getLastOrderQuery()
        
        lastOrderQuery.getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error saving order document (getting last order): \(String(describing: error))")
            } else {
                let lastOrder = querySnapshot?.documents.first
                let lastOrderId = lastOrder?.data()[FStoreConstants.orderIdField] as? Int ?? 0
                
                var newOrder = order
                newOrder.id = lastOrderId + 1
                
                self.save(order: newOrder)
                self.updateTotalBillWith(orderPrice: newOrder.cost)
                completionHandler()
            }
        }
    }
    
    func loadDefaultOrders(completionHandler: @escaping ()->()) {
        loadOrdersFrom(query: createDefaultOrdersQuery(), completionHandler: completionHandler)
    }
    
    func loadOrdersWith(status: Order.Status,
                        completionHandler: @escaping ()->()) {
        loadOrdersFrom(query: createQueryForOrdersWith(status: status),
                       completionHandler: completionHandler)
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
        
        ordersRef.addSnapshotListener { [self] (querySnapshot, error) in
            if error != nil {
                print("Error loading orders: \(String(describing: error))")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    self.orders = []
                    
                    for document in snapshotDocuments {
                        let order = self.loadOrder(from: document)
                        
                        self.orders.append(order)
                    }
                    
                    self.orders = self.orders.sorted(by: {$0.id! > $1.id!})
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
        let id = data[FStoreConstants.orderIdField] as! Int
        let room =  data[FStoreConstants.orderRoomField] as! Int
        let dateOrdered = dateOrderedTimestamp.dateValue()
        let datePicked = datePickedTimestamp.dateValue()
        let comment = data[FStoreConstants.orderCommentField] as! String
        let cost = data[FStoreConstants.orderCostField] as! Double
        let status = Order.Status(rawValue: statusString)
        let documentID = data[FStoreConstants.orderDocumentIDField] as! String
        
        let order = Order(name: name, id: id, room: room, dateOrdered: dateOrdered, datePicked: datePicked, comment: comment, cost: cost, status: status!, documentID: documentID)
        
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
            let roomId = Device.roomId
            ordersRef = db
                .collection(FStoreConstants.hotelsCollectionName)
                .document(Hotel.id)
                .collection(FStoreConstants.ordersCollectionName)
                .whereField(FStoreConstants.orderRoomField, isEqualTo: roomId)
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
    
    private func getLastOrderQuery() -> Query {
        let ordersRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
        let lastOrderQuery = ordersRef.order(by: FStoreConstants.orderIdField, descending: true).limit(to: 1)
        
        return lastOrderQuery
    }
    
    private func save(order: Order) {
        let orderRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
            .document()
        
        let documentID = orderRef.documentID
        
        orderRef.setData([
            FStoreConstants.orderNameField: order.name,
            FStoreConstants.orderCommentField: order.comment,
            FStoreConstants.orderIdField: order.id!,
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
        }
    }
    
    private func updateTotalBillWith(orderPrice: Double) {
        let roomId = Device.roomId
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document("\(roomId)")
        roomRef.getDocument { (document, error) in
            if error != nil {
                print("Error loading room: \(String(describing: error))")
            } else {
                if let document = document, document.exists {
                    let bill = document.data()![FStoreConstants.roomBillField] as! Double
                    let newBill = bill + orderPrice
                    roomRef.updateData([FStoreConstants.roomBillField: newBill])
                }
            }
        }
    }
    
}
