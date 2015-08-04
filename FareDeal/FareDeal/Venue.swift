//
//  Venue.swift
//  FareDeal
//
//  Created by Angela Smith on 8/2/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import RealmSwift
import UIKit

// IMPORTANT: Any changes to data model will either require migration (if app has been released to other devices) https://realm.io/docs/swift/latest/#migrations
// or deletion from device to reset


class Venue: Object {
    
    dynamic var identifier = ""
    dynamic var name = ""
    dynamic var imageName = ""
    dynamic var address = ""
    dynamic var distance: Float = 0.0
    dynamic var priceTier: Int = 0
    dynamic var phone = ""
    dynamic var webUrl = ""
    dynamic var hours = ""
    dynamic var imageData: NSData = NSData()
    dynamic var imagePresent: Bool = false
    dynamic var swipeValue: Int = 0
    dynamic var sourceType = ""
    dynamic var defaultDealTitle = ""
    dynamic var defaultDealDesc = ""
    dynamic var defaultDealValue: Float = 0.0
   // dynamic let defaultDeal = VenueDeal()
    var image: UIImage? {
        get {
            return UIImage(data: imageData)
        }
        set(newImage) {
            imageData = UIImagePNGRepresentation(newImage)
        }
    }
     // Specify properties to ignore (Realm won't persist)
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
    
    override class func primaryKey() -> String {
        return "identifier"
    }
    

}
