//
//  ServiceCreationViewController.swift
//  HotelS
//
//  Created by dimas on 26.05.2022.
//

import UIKit

final class ServiceCreationViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var serviceImageView: UIImageView!
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    @IBOutlet weak var serviceDescriptionLabel: UILabel!
    
    @IBOutlet weak var servicePriceLabel: UILabel!
    
    @IBOutlet weak var serviceNameTextField: UITextField!
    
    @IBOutlet weak var serviceDescriptionTextView: UITextView!
    
    @IBOutlet weak var servicePriceTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    //MARK: - Public properties
    let serviceManager = ServicesManager()
    
    var serviceCategory: Service.Category?
    var serviceToEdit: Service?
        
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - IBActions
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        createImagePickerController()
    }
    
    @IBAction func createServiceButtonTapped(_ sender: UIButton) {        
        if serviceToEdit != nil {
            updateService()
        } else {
            saveService()
        }
    }
    
}

//MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ServiceCreationViewController: UINavigationControllerDelegate,
                                         UIImagePickerControllerDelegate {
    
    func createImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        serviceImageView.image  = tempImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
