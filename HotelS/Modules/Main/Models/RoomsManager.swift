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
    let db = Firestore.firestore()
    var rooms = [Room]()
    
    //MARK: - Public methods
    
    func loadRooms(completionHandler: @escaping () -> ()) {
        let roomsRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .order(by: FStoreConstants.roomIdField)
        
        roomsRef.addSnapshotListener { (querySnapshot, error) in
            if error != nil {
                print("Error loading rooms: \(String(describing: error))")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    self.rooms = []
                    
                    for document in snapshotDocuments {
                        let room = self.createRoom(from: document)
                        
                        self.rooms.append(room)
                        
                        DispatchQueue.main.async {
                            completionHandler()
                        }
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
        db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .whereField(FStoreConstants.roomIdField, isEqualTo: room.id)
            .getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("Error loading rooms: \(String(describing: error))")
                } else {
                    if let documentsToDelete = querySnapshot?.documents {
                        self.deleteCancelledOrdersFor(room: room)
                        
                        for document in documentsToDelete {
                            document.reference.delete()
                        }
                        completionHandler()
                    }
                }
            }
    }
    
    //MARK: - Private methods
    private func createRoom(from document: QueryDocumentSnapshot) -> Room {
        let data = document.data()
        
        let roomNumber = data[FStoreConstants.roomIdField] as! Int
        let roomBill = data[FStoreConstants.roomBillField] as! Double
        
        let room = Room(id: roomNumber, bill: roomBill)
        
        return room
    }
    
    private func resetBillFor(room: Room) {
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName).document("\(room.id)")
        
        roomRef.getDocument { (document, error) in
            if error != nil {
                print("Error loading room: \(String(describing: error))")
            } else {
                if let document = document, document.exists {
                    roomRef.updateData([FStoreConstants.roomBillField: 0])
                }
            }
        }
    }
    
    private func deleteCancelledOrdersFor(room: Room) {
        let statusesToDelete = [Order.Status.new.rawValue, Order.Status.inProgress.rawValue, Order.Status.cancelled.rawValue]
        
        db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
            .whereField(FStoreConstants.orderRoomField, isEqualTo: room.id)
            .whereField(FStoreConstants.orderStatusField, in: statusesToDelete)
            .getDocuments { (querySnapshot, error) in
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
        db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
            .whereField(FStoreConstants.orderRoomField, isEqualTo: room.id)
            .whereField(FStoreConstants.orderStatusField, isEqualTo: Order.Status.completed.rawValue)
            .getDocuments { (querySnapshot, error) in
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
    
    
    //TODO: - Fix getRoomBill func
//    func getRoomBill(completionHandler: @escaping ()->()) {
//        let roomId = Device.roomId
//
//        let roomRef = db
//            .collection(FStoreConstants.hotelsCollectionName)
//            .document(Hotel.id)
//            .collection(FStoreConstants.roomsCollectionName)
//            .document("\(roomId)")
//
//        roomRef.getDocument { (document, error) in
//            if error != nil {
//                print("Error loading room: \(String(describing: error))")
//            } else {
//                if let document = document, document.exists {
//                    let bill = document.data()![FStoreConstants.roomBillField] as! Double
//                    completionHandler()
//                }
//            }
//        }
//    }
    
    func refundFor(order: Order, completionHandler: @escaping ()->()) {
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
                    let newBill = bill - order.cost
                    roomRef.updateData([FStoreConstants.roomBillField: newBill])
                    completionHandler()
                }
            }
        }
    }
}
