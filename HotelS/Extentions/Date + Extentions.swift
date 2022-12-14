//
//  Date.swift
//  HotelS
//
//  Created by dimas on 15.12.2022.
//

import Foundation

extension Date {
    
    var formattedString: String {
        let locale = Locale(identifier: DateFormatConstants.localeIdentifier)
        
        return self.formatted(
            .dateTime
                .locale(locale)
                .month()
                .day()
                .hour()
                .minute())
    }
    
}
