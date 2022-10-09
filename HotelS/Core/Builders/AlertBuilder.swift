//
//  AlertBuilder.swift
//  100days9(hangman)
//
//  Created by Nikita Lizogubov on 14/07/2021.
//

import UIKit

final class AlertBuilder {
    
    // MARK: - Public properties
    
    let alertController: UIAlertController
    
    // MARK: - Init
    
    init(style: UIAlertController.Style) {
        self.alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    }
    
    private init(_ alertController: UIAlertController) {
        self.alertController = alertController
    }
    
    // MARK: - Public methods
    
    func title(_ text: String) -> AlertBuilder {
        alertController.title = text
        return AlertBuilder(alertController)
    }
    
    func message(_ text: String) -> AlertBuilder {
        alertController.message = text
        return AlertBuilder(alertController)
    }
    
    func addButton(_ title: String, style: UIAlertAction.Style, completionHandler: ((UIAlertController) -> Void)?) -> AlertBuilder {
        let action = UIAlertAction(title: title, style: style) { (alertAction) in
            completionHandler?(self.alertController)
        }
        alertController.addAction(action)
        return AlertBuilder(alertController)
    }
    
    func addTextField(placeholder: String, keyboardType: UIKeyboardType) -> AlertBuilder {
        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.keyboardType = keyboardType
        }
        return AlertBuilder(alertController)
    }
    
}
