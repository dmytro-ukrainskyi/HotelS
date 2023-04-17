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
        servicesManager.loadServicesFor(category: serviceCategory!) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func edit(service: Service) {
        let viewControllerID = StoryboardConstants
            .serviceCreationViewControllerIdentifier
        
        if let viewController = storyboard?
            .instantiateViewController(withIdentifier: viewControllerID)
            as? ServiceCreationViewController {
            viewController.serviceCategory = service.category
            viewController.serviceToEdit = service
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func delete(service: Service) {
        self.servicesManager.delete(service: service) { [weak self] in
            self?.loadServices()
        }
    }
    
}
