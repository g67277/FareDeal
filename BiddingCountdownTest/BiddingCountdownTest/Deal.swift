//
//  Deal.swift
//  DealsSortTest
//
//  Created by Angela Smith on 7/22/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class Deal: NSObject, Printable, DebugPrintable {

    var name: String
    var desc: String
    var timeLimit: Int
    var tier: Int
    var value: Float
    var isDefault: Bool
    var restId: String
    var dealId: String
    
    init(name: String, desc: String, timeLimit: Int, tier: Int, value: Float, isDefault: Bool, restId: String, dealId: String) {
        self.name = name
        self.desc = desc
        self.timeLimit = timeLimit
        self.tier = tier
        self.value = value
        self.isDefault = isDefault
        self.restId = restId
        self.dealId = dealId
    }

}
