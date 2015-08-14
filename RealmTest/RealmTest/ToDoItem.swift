//
//  ToDoItem.swift
//  RealmTest
//
//  Created by Nazir Shuqair on 8/1/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoItem:Object{
    dynamic var name = "" // [3]
    dynamic var value = 0.0
    dynamic var finished = false
    dynamic var id = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}