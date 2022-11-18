//
//  ServiceCreationViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import UIKit
import SDWebImage

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
        let service = createService()
        if let serviceImage = getImageData() {
            serviceManager.save(service: service, withImage: serviceImage) {
                self.showSuccessAlert()
            }
        }
    }
    
    //TODO: Prevent image from compressing while updating service
    func updateService() {
        let service = createService()
        if let serviceImage = getImageData() {
            serviceManager.update(service: service, withImage: serviceImage) {
                self.showSuccessAlert()
            }
        }
    }
    
    func loadServiceImage() {
        if let service = serviceToEdit {
            serviceImageView.sd_setImage(with: service.imageURL)
        }
    }
    
    //MARK: - Private methods
    private func createService() -> Service {
        let priceString = servicePriceTextField.text!
        
        let name = serviceNameTextField.text!
        let description = serviceDescriptionTextView.text!
        let price = Double(priceString) ?? 0
        let category = serviceCategory
        let documentID = serviceToEdit?.documentID
        
        let service = Service(name: name, description: description, price: price, category: category!, documentID: documentID)
        
        return service
    }
    
    private func getImageData() -> Data? {
        guard let imageData = serviceImageView.image?.jpegData(compressionQuality: 0.5) else {
            showMissingImageError()
            return nil
        }
        
        guard imageData.count < 1 * 1024 * 1024 else {
            showImageSizeError()
            return nil
        }
        
        return imageData
    }
}
