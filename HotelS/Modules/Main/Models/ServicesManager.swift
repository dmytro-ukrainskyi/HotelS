//
//  Services.swift
//  HotelS
//
//  Created by dimas on 01.07.2022.
//

import Foundation
import Firebase

class ServicesManager {
    
    //MARK: - Public properties
    let db = Firestore.firestore()
    var services = [Service]()
    
    //MARK: - Public methods
    func save(service: Service, completionHandler: @escaping ()->()) {
        let servicesRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.servicesCollectionName)
        
        servicesRef.addDocument(data: [
            FStoreConstants.serviceNameField: service.name,
            FStoreConstants.serviceDescriptionField: service.description,
            FStoreConstants.servicePriceField: service.price,
            FStoreConstants.serviceCategoryField: service.category.rawValue,
            FStoreConstants.serviceImageField: service.image!
        ]) {_ in
            completionHandler()
        }
        
    }
    
    func loadServicesFor(category: Service.Category, completionHandler: @escaping ()->()) {
        let servicesRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.servicesCollectionName)
            .order(by: FStoreConstants.serviceNameField)
            .whereField(FStoreConstants.serviceCategoryField, isEqualTo: category.rawValue)
        
        servicesRef.addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error loading services: \(String(describing: error))")
                return
            }
            if let snapshotDocuments = querySnapshot?.documents {
                self.services = []
                
                for document in snapshotDocuments {
                    let service = self.createService(from: document)
                    
                    self.services.append(service)
                }
                completionHandler()
            }
        }
    }
    
    func update(service: Service, completionHandler: @escaping ()->()) {
        db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.servicesCollectionName)
            .whereField(FStoreConstants.serviceNameField, isEqualTo: service.name)
            .getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("Error loading services: \(String(describing: error))")
                } else {
                    if let documentsToUpdate = querySnapshot?.documents {
                        for document in documentsToUpdate {
                            document.reference.updateData([
                                FStoreConstants.serviceNameField: service.name,
                                FStoreConstants.serviceDescriptionField: service.description,
                                FStoreConstants.servicePriceField: service.price,
                                FStoreConstants.serviceImageField: service.image!
                            ])
                        }
                    }
                    completionHandler()
                }
            }
    }
    
    func delete(service: Service, completionHandler: @escaping ()->()) {
        db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.servicesCollectionName)
            .whereField(FStoreConstants.serviceNameField, isEqualTo: service.name)
            .getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("Error loading orders: \(String(describing: error))")
                } else {
                    if let documentsToDelete = querySnapshot?.documents {
                        for document in documentsToDelete {
                            document.reference.delete()
                        }
                        completionHandler()
                    }
                }
            }
    }
    
    //MARK: - Private methods
    private func createService(from document: QueryDocumentSnapshot) -> Service {
        let data = document.data()
        let categoryString = data[FStoreConstants.serviceCategoryField] as! String
        
        let name = data[FStoreConstants.serviceNameField] as! String
        let description = data[FStoreConstants.serviceDescriptionField] as! String
        let price = data[FStoreConstants.servicePriceField] as! Double
        let category = Service.Category(rawValue: categoryString)!
        
        var service = Service(name: name, description: description, price: price, category: category)
        
        if let image = data[FStoreConstants.serviceImageField] as? String {
            service.image = image
        }
        
        return service
    }
    
}
