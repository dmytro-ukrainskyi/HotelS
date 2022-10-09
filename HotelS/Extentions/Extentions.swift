//
//  Extentions.swift
//  HotelS
//
//  Created by dimas on 27.05.2022.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension Double {
    
    var currencyString: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: "en_US")
            numberFormatter.numberStyle = NumberFormatter.Style.currency
            return numberFormatter.string(from: self as NSNumber)!
        }
    }
    
}




