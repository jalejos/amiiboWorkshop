//
//  Amiibo.swift
//  AmiiboDisplayer
//
//  Created by Alejos on 9/3/18.
//  Copyright © 2018 Alejos. All rights reserved.
//

import Foundation
import ObjectMapper

class Amiibo: Mappable {
    var name = ""
    var date = Date()
    
    init() {}
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["character"]
        date <- (map["release.na"], DateTransform())
    }
    
}
