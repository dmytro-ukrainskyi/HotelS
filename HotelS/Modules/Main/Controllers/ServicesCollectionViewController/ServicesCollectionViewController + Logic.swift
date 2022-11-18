//
//  ServicesCollectionViewController + Logic.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import Foundation

extension ServicesCollectionViewController {
    
    //MARK: - Public methods
    func loadServices() {
        servicesManager.loadServicesFor(category: serviceCategory!) {
            self.collectionView.reloadData()
        }
    }
    
    func edit(service: Service) {
        let vcId = StoryboardConstants.serviceCreationViewControllerIdentifier
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: vcId) as? ServiceCreationViewController {
            vc.serviceCategory = service.category
            vc.serviceToEdit = service
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func delete(service: Service) {
        self.servicesManager.delete(service: service) {
            self.loadServices()
        }
    }
}
