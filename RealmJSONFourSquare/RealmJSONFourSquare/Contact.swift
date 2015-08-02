//
//  Contact.swift
//  RealmJSONFourSquare
//
//  Created by Angela Smith on 8/1/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import RealmSwift

class Contact: Object {
    
    dynamic var phone = ""
    
    override static func primaryKey() -> String? {
        return "phone"
    }
}
