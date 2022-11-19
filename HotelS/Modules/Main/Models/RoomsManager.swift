//
//  Rooms.swift
//  HotelS
//
//  Created by dimas on 03.07.2022.
//

import Foundation
import Firebase

class RoomsManager {
    
    //MARK: - Public properties
    private(set) var rooms = [Room]()
    
    //MARK: - Private properties
    private let db = Firestore.firestore()
    
    //MARK: - Public methods
    func saveRoom(roomNumber: Int) {
        let defaultRoomBill = 0
        
        let documentID = String(roomNumber)
        
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(documentID)
        
        
        roomRef.setData([
            FStoreConstants.roomNumberField: roomNumber,
            FStoreConstants.roomBillField: defaultRoomBill,
        ])
    }
    
    func loadRooms(completionHandler: @escaping () -> ()) {
        let roomsRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .order(by: FStoreConstants.roomNumberField)
        
        roomsRef.addSnapshotListener { (querySnapshot, error) in
            if error != nil {
                print("Error loading rooms: \(String(describing: error))")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    self.rooms = []
                    
                    for document in snapshotDocuments {
                        let room = self.createRoom(from: document)
                        
                        self.rooms.append(room)
                        
                        completionHandler()
                    }
                }
            }
        }
    }
    
    func checkOut(room: Room, completionHandler: @escaping () -> ()) {
        resetBillFor(room: room)
        deleteCancelledOrdersFor(room: room)
        updateCompletedOrdersAsPaidFor(room: room)
        
        completionHandler()
    }
    
    func delete(room: Room, completionHandler: @escaping () -> ()) {
        let roomDocumentID = String(room.number)
        
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(roomDocumentID)
        
        roomRef.delete() { error in
            if error != nil {
                print("Error deleting room: \(String(describing: error))")
            }
            
            self.deleteCancelledOrdersFor(room: room)
            
            completionHandler()
        }
    }
    
    func getRoomBill(completionHandler: @escaping (Double)->()) {
        let roomNumber = Device.roomNumber!
        
        let roomDocumentID = String(roomNumber)
        
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(roomDocumentID)
        
        roomRef.getDocument { document, error in
            if error != nil {
                print("Error loading room: \(String(describing: error))")
            } else {
                if let document = document {
                    let data = document.data()!
                    let bill = data[FStoreConstants.roomBillField] as! Double
                    
                    completionHandler(bill)
                }
            }
        }
    }
    
    func updateRoomsTotalBillWith(orderPrice: Double) {
        let roomDocumentId = String(Device.roomNumber!)
        
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(roomDocumentId)
        
        roomRef.getDocument { (document, error) in
            if error != nil {
                print("Error loading room: \(String(describing: error))")
            } else {
                if let roomDocument = document {
                    let bill = roomDocument.data()![FStoreConstants.roomBillField] as! Double
                    let newBill = bill + orderPrice
                    
                    roomRef.updateData([FStoreConstants.roomBillField: newBill])
                }
            }
        }
    }
    
    func refundFor(order: Order, completionHandler: @escaping ()->()) {
        let roomDocumentId = String(order.room)
        
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(roomDocumentId)
        
        roomRef.getDocument { document, error in
            if error != nil {
                print("Error loading room: \(String(describing: error))")
            } else {
                if let roomDocument = document {
                    let bill = roomDocument.data()![FStoreConstants.roomBillField] as! Double
                    let newBill = bill - order.cost
                    
                    roomRef.updateData([FStoreConstants.roomBillField: newBill])
                    
                    completionHandler()
                }
            }
        }
    }
    
    //MARK: - Private methods
    private func createRoom(from document: QueryDocumentSnapshot) -> Room {
        let data = document.data()
        
        let roomNumber = data[FStoreConstants.roomNumberField] as! Int
        let roomBill = data[FStoreConstants.roomBillField] as! Double
        
        let room = Room(number: roomNumber, bill: roomBill)
        
        return room
    }
    
    private func resetBillFor(room: Room) {
        let newRoomBill = 0
        
        let roomDocumentID = String(room.number)
        
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(roomDocumentID)
        
        roomRef.updateData([FStoreConstants.roomBillField: newRoomBill])
    }
    
    private func deleteCancelledOrdersFor(room: Room) {
        let statusesToDelete = [Order.Status.new.rawValue, Order.Status.inProgress.rawValue, Order.Status.cancelled.rawValue]
        
        let ordersRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
            .whereField(FStoreConstants.orderRoomField, isEqualTo: room.number)
            .whereField(FStoreConstants.orderStatusField, in: statusesToDelete)
        
        ordersRef.getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error loading orders: \(String(describing: error))")
            } else {
                if let documentsToDelete = querySnapshot?.documents {
                    for document in documentsToDelete {
                        document.reference.delete()
                    }
                }
            }
        }
    }
    
    private func updateCompletedOrdersAsPaidFor(room: Room) {
        let ordersRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
            .whereField(FStoreConstants.orderRoomField, isEqualTo: room.number)
            .whereField(FStoreConstants.orderStatusField, isEqualTo: Order.Status.completed.rawValue)
        
        ordersRef.getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error loading orders: \(String(describing: error))")
            } else {
                if let documentsToUpdate = querySnapshot?.documents {
                    for document in documentsToUpdate {
                        document.reference.updateData([
                            FStoreConstants.orderStatusField: Order.Status.paid.rawValue])
                    }
                }
            }
        }
    }
    
}
