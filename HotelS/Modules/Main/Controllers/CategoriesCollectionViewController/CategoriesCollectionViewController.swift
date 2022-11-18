//
//  ViewController.swift
//  HotelS
//
//  Created by dimas on 18.05.2022.
//

import UIKit

final class CategoriesCollectionViewController: UICollectionViewController {
    
    //MARK: - Public properties
    let loginManager = LoginManager()
    let serviceCategories = Service.categories
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setupUI()
    }
    
    //MARK: - IBActions
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem) {
        //showAuthorizationAlert()
        logOut()
    }
}

