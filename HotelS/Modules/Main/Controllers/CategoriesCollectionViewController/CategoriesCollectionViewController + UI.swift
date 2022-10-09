//
//  CategoriesCollectionViewController + UI.swift
//  HotelS
//
//  Created by dimas on 04.06.2022.
//

import UIKit

extension CategoriesCollectionViewController {
    
    //MARK: - Public methods
    func setupUI() {
        hideKeyboardWhenTappedAround()
        setupNavigationBar()
    }
    
    func showFailedAuthAlert() {
        let alertController = AlertBuilder(style: .alert)
            .title("Error logging out")
            .message("Invalid email or password")
            .addButton("OK", style: .cancel, completionHandler: nil)
            .alertController
        present(alertController, animated: true)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Device.hotelName

        if !Device.isAdmin, navigationItem.rightBarButtonItems!.count > 1 {
            navigationItem.rightBarButtonItems?.removeLast()
        }

    }
}
