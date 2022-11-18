//
//  SevicesCollectionViewController.swift
//  HotelS
//
//  Created by dimas on 23.05.2022.
//

import UIKit

final class ServicesCollectionViewController: UICollectionViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var addServiceButton: UIBarButtonItem!
    
    //MARK: - Public properties
    var serviceCategory: Service.Category?
    var servicesManager = ServicesManager()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadServices()
    }
    
    //MARK: - IBActions
    @IBAction func unwindToServices(_ sender: UIStoryboardSegue) {
        
    }
}
