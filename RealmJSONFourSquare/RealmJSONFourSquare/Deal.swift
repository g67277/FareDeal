//
//  Deal.swift
//  RealmJSONFourSquare
//
//  Created by Angela Smith on 8/1/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import RealmSwift
import UIKit


// IMPORTANT: Any changes to data model will either require migration (if app has been released to other devices) https://realm.io/docs/swift/latest/#migrations
// or deletion from device to reset

class Deal: Object {
    
    dynamic var name = ""
    dynamic var desc = ""
    dynamic var timeLimit: Int = 0
    dynamic var tier: Int = 0
    dynamic var value: Float = 0.0
    dynamic var isDefault = false
    dynamic var restId = ""
    dynamic var dealId = ""
    dynamic var firstPull = NSDate()
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
