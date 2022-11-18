//
//  LoginViewController.swift
//  HotelS
//
//  Created by dimas on 29.05.2022.
//

import UIKit

final class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var appNameLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var adminSwitch: UISwitch!
    
    //MARK: - Public properties
    let loginManager = LoginManager()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        setupUI()
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        signIn()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        showRegistrationAlert()
    }
}
