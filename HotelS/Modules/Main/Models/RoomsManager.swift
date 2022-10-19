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
    //TODO: - Refactor using documentID
    func saveRoom(roomNumber: Int) {
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document()
        
        let documentID = roomRef.documentID
        
        roomRef.setData([
            FStoreConstants.roomNumberField: roomNumber,
            FStoreConstants.roomBillField: 0,
            FStoreConstants.roomDocumentIDField: documentID
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
                        //TODO: - Move DispatchQueue from here (?)
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
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(room.documentID!)
        
        roomRef.delete() { error in
            if error != nil {
                print("Error deleting room: \(String(describing: error))")
            }
                
            self.deleteCancelledOrdersFor(room: room)
                completionHandler()
            }
    }
    
    //MARK: - Private methods
    private func createRoom(from document: QueryDocumentSnapshot) -> Room {
        let data = document.data()
        
        let roomNumber = data[FStoreConstants.roomNumberField] as! Int
        let roomBill = data[FStoreConstants.roomBillField] as! Double
        let documentID = data[FStoreConstants.roomDocumentIDField] as! String
        
        let room = Room(number: roomNumber, bill: roomBill, documentID: documentID)
        
        return room
    }
    
    private func resetBillFor(room: Room) {
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(room.documentID!)
        
        roomRef.updateData([FStoreConstants.roomBillField: 0])
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
        let roomNumber = Device.roomNumber!
        
        let roomRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document("\(roomNumber)")
        
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
