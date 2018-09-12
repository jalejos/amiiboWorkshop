//
//  DateTransform.swift
//  AmiiboDisplayer
//
//  Created by Alejos on 9/3/18.
//  Copyright © 2018 Alejos. All rights reserved.
//

import Foundation
import ObjectMapper

class DateTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> Date? {
        guard let dateString = value as? String else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        
        return date
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        guard let dateValue = value else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let string = dateFormatter.string(from: dateValue)
        return string
    }
}
