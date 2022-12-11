//
//  AlertBuilder.swift
//  100days9(hangman)
//
//  Created by Nikita Lizogubov on 14/07/2021.
//

import UIKit

final class AlertBuilder {
    
    //MARK: - Public properties
    var textFields: [UITextField]? {
        return alertController.textFields
    }
    
    // MARK: - Private properties
    private let alertController: UIAlertController
    
    // MARK: - Lifecycle
    init(style: UIAlertController.Style) {
        self.alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    }
    
    private init(_ alertController: UIAlertController) {
        self.alertController = alertController
    }
    
    // MARK: - Public methods
    func build() -> UIAlertController {
        return alertController
    }
    
    func title(_ text: String) -> AlertBuilder {
        alertController.title = text
        
        return AlertBuilder(alertController)
    }
    
    func message(_ text: String) -> AlertBuilder {
        alertController.message = text
        
        return AlertBuilder(alertController)
    }
    
    func addButton(_ title: String, style: UIAlertAction.Style, completionHandler: (() -> Void)?) -> AlertBuilder {
        let action = UIAlertAction(title: title, style: style) { alertAction in
            completionHandler?()
        }
        
        alertController.addAction(action)
        
        return AlertBuilder(alertController)
    }
    
    func addTextField(placeholder: String, keyboardType: UIKeyboardType) -> AlertBuilder {
        alertController.addTextField { textField in
            textField.placeholder = placeholder
            textField.keyboardType = keyboardType
        }
        
        return AlertBuilder(alertController)
    }
    
}
