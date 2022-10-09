//
//  CategoriesCollectionViewController + Collection View.swift
//  HotelS
//
//  Created by dimas on 04.06.2022.
//

import UIKit

extension CategoriesCollectionViewController {
    
    //MARK: - Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        serviceCategories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardConstants.categoryCellReuseIdentifier, for: indexPath) as! CategoryCell
        
        cell.categoryNameLabel?.text = serviceCategories[indexPath.row]
        cell.categoryImageView.image = Service.categoriesImages[indexPath.row]
        
        return cell
    }
    
    //MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.toServicesSegueIdentifier {
            let destinationVC = segue.destination as! ServicesCollectionViewController
            
            if let cell = sender as? UICollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell) {
                let categoryString = serviceCategories[indexPath.item]
                destinationVC.serviceCategory = Service.Category(rawValue: categoryString)
            }
        }
    }
    
}
