//
//  ServiceCreationViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import UIKit

extension ServiceCreationViewController {
    
    //MARK: - Public methods
    func goBackToServicesVC() {
        self.performSegue(withIdentifier: StoryboardConstants.unwindToServices, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.unwindToServices {
            let destinationVC = segue.destination as! ServicesCollectionViewController
            destinationVC.serviceCategory = serviceCategory
            destinationVC.loadServices()
        }
    }
    
    func saveService() {
        serviceManager.save(service: createService()) {
            self.showSuccessAlert()
        }
    }
    
    func updateService() {
        serviceManager.update(service: createService()) {
            self.showSuccessAlert()
        }
    }
    
    //MARK: - Private methods
    private func createService() -> Service {
        let priceString = servicePriceTextField.text!
        
        let name = serviceNameTextField.text!
        let description = serviceDescriptionTextView.text!
        let price = Double(priceString) ?? 0
        let category = serviceCategory
        let image = "\(name).jpg"
        
        let service = Service(name: name, description: description, price: price, category: category!, image: image)
        
        return service
    }
    
    //TODO: - Manage Service Images
    
    //    func loadServiceImage() {
    //        guard let imageName = serviceToEdit!.image else {return}
    //
    //        let imageRef = storage
    //            .reference()
    //            .child(Hotel.id)
    //            .child("images")
    //            .child(imageName)
    //        imageRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] (data, error) in
    //            if error != nil {
    //                print("Error loading service image: \(String(describing: error))")
    //            } else {
    //                if let data = data {
    //                    self?.serviceImageView.image = UIImage(data: data)
    //                }
    //            }
    //        }
    //    }
    
    //    private func saveServiceImageWith(name: String) -> Bool {
    //        guard let imageData = serviceImageView.image?.jpegData(compressionQuality: 1) else {
    //            showMissingImageError()
    //            return false
    //        }
    //
    //        if imageData.count > 1 * 1024 * 1024 {
    //            showImageSizeError()
    //            return false
    //        } else {
    //            let uploadRef = storage.reference().child(Hotel.id).child("images").child(name)
    //            uploadRef.putData(imageData)
    //            return true
    //        }
    //
    //    }
    
}
