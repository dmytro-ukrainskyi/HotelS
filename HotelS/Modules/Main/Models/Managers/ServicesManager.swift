//
//  Services.swift
//  HotelS
//
//  Created by dimas on 01.07.2022.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

final class ServicesManager {
    
    //MARK: - Public properties
    private(set) var services = [Service]()
    
    //MARK: - Private properties
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    //MARK: - Public methods
    func save(service: Service, withImage image: Data, completionHandler: @escaping ()->()) {
        let serviceRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.servicesCollectionName)
            .document()
        
        let documentID = serviceRef.documentID
        
        serviceRef.setData([
            FStoreConstants.serviceNameField: service.name,
            FStoreConstants.serviceDescriptionField: service.description,
            FStoreConstants.servicePriceField: service.price,
            FStoreConstants.serviceCategoryField: service.category.rawValue,
            FStoreConstants.serviceDocumentIDField: serviceRef.documentID
        ]) { error in
            if let error = error {
                print("Error saving service: \(error)")
                return
            }
            
            var serviceWithID = service
            serviceWithID.documentID = documentID
            
            self.save(serviceImage: image, forService: serviceWithID)
            
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
        
        servicesRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error loading services: \(error)")
                return
            }
            
            if let documents = querySnapshot?.documents {
                self.services = []
                
                for document in documents {
                    let service = self.getService(from: document)
                    
                    self.services.append(service)
                }
                
                completionHandler()
            }
        }
    }
    
    func update(service: Service, withImage image: Data, completionHandler: @escaping ()->()) {
        let serviceRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.servicesCollectionName)
            .document(service.documentID!)
        
        serviceRef.updateData([
            FStoreConstants.serviceNameField: service.name,
            FStoreConstants.serviceDescriptionField: service.description,
            FStoreConstants.servicePriceField: service.price,
        ]) {_ in
            self.save(serviceImage: image, forService: service)
            
            completionHandler()
        }
    }
    
    func delete(service: Service, completionHandler: @escaping ()->()) {
        let serviceRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.servicesCollectionName)
            .document(service.documentID!)
        
        serviceRef.delete() { error in
            if let error = error {
                print("Error deleting service: \(error)")
                return
            }
            
            self.deleteImage(forService: service)
            
            completionHandler()
        }
    }
    
    //MARK: - Private methods
    private func getService(from document: QueryDocumentSnapshot) -> Service {
        let data = document.data()
        let categoryString = data[FStoreConstants.serviceCategoryField] as! String
        let imageURLString = data[FStoreConstants.serviceImageURLField] as? String
        
        let name = data[FStoreConstants.serviceNameField] as! String
        let description = data[FStoreConstants.serviceDescriptionField] as! String
        let price = data[FStoreConstants.servicePriceField] as! Double
        let category = Service.Category(rawValue: categoryString)!
        let imageURL = URL(string: imageURLString ?? "")
        let documentID = data[FStoreConstants.serviceDocumentIDField] as! String
        
        let service = Service(name: name, description: description, price: price, category: category, imageURL: imageURL, documentID: documentID)
        
        return service
    }
    
    private func save(serviceImage: Data, forService service: Service) {
        let uploadRef = storage
            .reference()
            .child("Service images")
            .child(Hotel.id)
            .child(service.category.rawValue)
            .child(service.name)
        
        let uploadTask = uploadRef.putData(serviceImage)
        
        uploadTask.observe(.success) { _ in
            uploadRef.downloadURL { result in
                switch result {
                case .success(let url):
                    self.updateServiceImageURL(forService: service, with: url)
                case .failure(let error):
                    print("Error updating image URL: \(error)")
                }
            }
        }
    }
    
    private func updateServiceImageURL(forService service: Service, with url: URL) {
        let serviceRef = db
            .collection(FStoreConstants.hotelsCollectionName)
            .document(Hotel.id)
            .collection(FStoreConstants.servicesCollectionName)
            .document(service.documentID!)
        
        serviceRef.updateData([
            FStoreConstants.serviceImageURLField: url.absoluteString,
        ])
    }
    
    private func deleteImage(forService service: Service) {
        let imageRef = storage
            .reference()
            .child("Service images")
            .child(Hotel.id)
            .child(service.category.rawValue)
            .child(service.name)
        
        imageRef.delete() { error in
            print("Error deleting image: \(String(describing: error))")
        }
    }
    
}
