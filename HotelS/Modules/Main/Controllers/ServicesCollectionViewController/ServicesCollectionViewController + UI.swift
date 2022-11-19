//
//  ServicesCollectionViewController + UI.swift
//  HotelS
//
//  Created by dimas on 28.05.2022.
//

import UIKit

extension ServicesCollectionViewController: UIGestureRecognizerDelegate {
    
    func setupUI() {
        navigationItem.title = serviceCategory?.rawValue
        setupLongGestureRecognizerOnCollection()
        manageAddServiceButton()
    }
    
    private func manageAddServiceButton() {
        if !Device.isAdmin {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    //MARK: - Gesture recognition
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        
        collectionView?.addGestureRecognizer(longPressedGesture)
    }

    @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }

        let pointPressed = gestureRecognizer.location(in: collectionView)

        if let indexPath = collectionView?.indexPathForItem(at: pointPressed) {
            let serviceToManage = servicesManager.services[indexPath.item]
            let actionSheet = createServiceActionSheet(for: serviceToManage)
            
            show(actionSheet, at: indexPath)
        }
    }
    
    //MARK: - Action sheet
    func show(_ alertController: UIAlertController, at indexPath: IndexPath) {
        if let popoverController = alertController.popoverPresentationController {
            let cell = collectionView.cellForItem(at: indexPath)
            popoverController.sourceView = cell
            popoverController.sourceRect = cell!.bounds
        }
        
        present(alertController, animated: true)
    }
    
    func createServiceActionSheet(for service: Service) -> UIAlertController {
        let alertController = AlertBuilder(style: .actionSheet)
            .message("Manage service")
            .addButton("Edit", style: .default) {_ in
                self.edit(service: service)
            }
            .addButton("Delete", style: .destructive) {_ in
                self.delete(service: service)
            }
            .alertController
        
        return alertController
    }

}
