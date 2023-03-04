//
//  Rooms.swift
//  HotelS
//
//  Created by dimas on 03.07.2022.
//

import Foundation
import Firebase

final class RoomsManager {
    
    //MARK: - Public properties
    private(set) var rooms = [Room]()
    
    //MARK: - Private properties
    private let firestore = Firestore.firestore()
    
    //MARK: - Public methods
    func saveRoom(roomNumber: Int) {
        let defaultRoomBill = 0
        
        let documentID = String(roomNumber)
        
        let roomRef = firestore
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
        let roomsRef = firestore
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .order(by: FStoreConstants.roomNumberField)
        
        roomsRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error loading rooms: \(error)")
                return
            }
            
            if let snapshotDocuments = querySnapshot?.documents {
                self.rooms = []
                
                for document in snapshotDocuments {
                    let room = self.getRoom(from: document)
                
                    self.rooms.append(room)
                }
                
                completionHandler()
            }
        }
    }
    
    func checkOut(room: Room, completionHandler: @escaping () -> ()) {
        resetBillFor(room: room)
        deleteIncompleteOrdersFor(room: room)
        updateCompletedOrdersAsPaidFor(room: room)
        
        completionHandler()
    }
    
    func delete(room: Room, completionHandler: @escaping () -> ()) {
        let roomDocumentID = String(room.number)
        
        let roomRef = firestore
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(roomDocumentID)
        
        roomRef.delete() { error in
            if let error = error {
                print("Error deleting room: \(error)")
                return
            }
            
            self.deleteIncompleteOrdersFor(room: room)
            
            completionHandler()
        }
    }
    
    func getRoomBill(completionHandler: @escaping (Double)->()) {
        guard let roomNumber = Device.roomNumber else { return }
        
        let roomDocumentID = String(roomNumber)
        
        let roomRef = firestore
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(roomDocumentID)
        
        roomRef.getDocument { document, error in
            if let error = error {
                print("Error loading room: \(error)")
                return
            }
            
            if let data = document?.data() {
                let bill = data[FStoreConstants.roomBillField] as! Double
                
                completionHandler(bill)
            }
        }
    }
    
    func updateRoomsTotalBillWith(orderPrice: Double) {
        let roomDocumentId = String(Device.roomNumber!)
        
        let roomRef = firestore
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(roomDocumentId)
        
        roomRef.getDocument { document, error in
            if let error = error {
                print("Error loading room: \(error)")
                return
            }
            
            if let data = document?.data() {
                let bill = data[FStoreConstants.roomBillField] as! Double
                let newBill = bill + orderPrice
                
                roomRef.updateData([FStoreConstants.roomBillField: newBill])
            }
        }
    }
    
    func refundFor(order: Order, completionHandler: @escaping ()->()) {
        let roomDocumentId = String(order.room)
        
        let roomRef = firestore
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(roomDocumentId)
        
        roomRef.getDocument { document, error in
            if let error = error {
                print("Error loading room: \(error)")
                return
            }
            
            if let data = document?.data() {
                let bill = data[FStoreConstants.roomBillField] as! Double
                let newBill = bill - order.cost
                    
                roomRef.updateData([FStoreConstants.roomBillField: newBill])
                    
                completionHandler()
            }
        }
    }
    
    //MARK: - Private methods
    private func getRoom(from document: QueryDocumentSnapshot) -> Room {
        let data = document.data()
        
        let roomNumber = data[FStoreConstants.roomNumberField] as! Int
        let roomBill = data[FStoreConstants.roomBillField] as! Double
        
        let room = Room(number: roomNumber, bill: roomBill)
        
        return room
    }
    
    private func resetBillFor(room: Room) {
        let newRoomBill = 0
        
        let roomDocumentID = String(room.number)
        
        let roomRef = firestore
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.roomsCollectionName)
            .document(roomDocumentID)
        
        roomRef.updateData([FStoreConstants.roomBillField: newRoomBill])
    }
    
    private func deleteIncompleteOrdersFor(room: Room) {
        let statusesToDelete = [Order.Status.new.rawValue,
                                Order.Status.inProgress.rawValue,
                                Order.Status.cancelled.rawValue]
        
        let ordersRef = firestore
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
            .whereField(FStoreConstants.orderRoomField, isEqualTo: room.number)
            .whereField(FStoreConstants.orderStatusField, in: statusesToDelete)
        
        ordersRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error loading orders: \(error)")
                return
            }
               
            if let documentsToDelete = querySnapshot?.documents {
                for document in documentsToDelete {
                    document.reference.delete()
                }
            }
        }
    }
    
    private func updateCompletedOrdersAsPaidFor(room: Room) {
        let ordersRef = firestore
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.ordersCollectionName)
            .whereField(FStoreConstants.orderRoomField, isEqualTo: room.number)
            .whereField(FStoreConstants.orderStatusField, isEqualTo: Order.Status.completed.rawValue)
        
        ordersRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error loading orders: \(error)")
                return
            }
            
            if let documentsToUpdate = querySnapshot?.documents {
                for document in documentsToUpdate {
                    document.reference.updateData([
                        FStoreConstants.orderStatusField: Order.Status.paid.rawValue])
                }
            }
        }
    }
    
}
