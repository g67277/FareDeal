//
//  Deals.swift
//  FareDeal
//
//  Created by Angela Smith on 7/30/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class Deals: NSObject, Printable, DebugPrintable {
    
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
