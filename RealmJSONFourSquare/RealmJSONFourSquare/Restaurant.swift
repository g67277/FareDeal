//
//  Restaurant.swift
//  RealmJSONFourSquare
//
//  Created by Angela Smith on 8/1/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import RealmSwift

// IMPORTANT: Any changes to data model will either require migration (if app has been released to other devices) https://realm.io/docs/swift/latest/#migrations
// or deletion from device to reset

class Restaurant: Object {
    
    dynamic var identifier = ""
    dynamic var name = ""
    dynamic var imageName = ""
    dynamic var address = ""
    dynamic var distance: Float = 0.0
    dynamic var priceTier: Int = 0
    dynamic var phone = ""
    dynamic var webUrl = ""
    dynamic var hours = ""
    dynamic let deals = List<Deal>()
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
