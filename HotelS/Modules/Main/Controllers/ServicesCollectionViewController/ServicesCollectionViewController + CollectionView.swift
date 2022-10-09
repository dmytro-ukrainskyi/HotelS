//
//  ServicesCollectionViewController + CollectionView.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import UIKit

extension ServicesCollectionViewController {
    
    //MARK: - Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        servicesManager.services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardConstants.serviceCellReuseIdentifier, for: indexPath) as! ServiceCell
        
        let service = servicesManager.services[indexPath.row]
        
        cell.serviceNameLabel!.text = service.name
        cell.servicePriceLabel!.text = service.price.currencyString
        cell.serviceImageView.image = UIImage()

        return cell
    }
    
    //MARK: - Collection View Delegate
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if Device.isAdmin, identifier == StoryboardConstants.toOrderSegueIdentifier {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.toOrderSegueIdentifier {
            let destinationVC = segue.destination as! OrderViewController
            
            if let cell = sender as? UICollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell) {
                destinationVC.service = servicesManager.services[indexPath.item]
            }
        } else if segue.identifier == StoryboardConstants.toServiceCreationSegueIdentifier {
            let destinationVC = segue.destination as! ServiceCreationViewController
            destinationVC.serviceCategory = serviceCategory
        }
    }
    
}
