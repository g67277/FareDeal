//
//  Venue.swift
//  RealmJSONFourSquare
//
//  Created by Angela Smith on 8/1/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import RealmSwift

class Venue: Object {
    dynamic var id = ""
    dynamic var location = Location()
    dynamic var name = ""
    // photos
    dynamic var price = Price()
    dynamic var contact = Contact()
    
    dynamic var imageName = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}
