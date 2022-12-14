//
//  Extentions.swift
//  HotelS
//
//  Created by dimas on 27.05.2022.
//

import Foundation

extension Double {
    
    var currencyString: String {
        let locale = Locale(identifier: CurrencyFormatConstants.localeIdentifier)
        let code = CurrencyFormatConstants.currencyCode
        
        return self.formatted(.currency(code: code).locale(locale))
    }
    
}
