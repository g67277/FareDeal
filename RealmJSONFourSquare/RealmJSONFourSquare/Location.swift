//
//  Location.swift
//  RealmJSONFourSquare
//
//  Created by Angela Smith on 8/1/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import RealmSwift

class Location: Object {
    
// Specify properties to ignore (Realm won't persist these)
   // dynamic var lat = 0.0  // latitude
   // dynamic var lng = 0.0  // longitude
    dynamic var address = ""
    dynamic var city = ""
    dynamic var state = ""
    dynamic var postalCode = ""
}
