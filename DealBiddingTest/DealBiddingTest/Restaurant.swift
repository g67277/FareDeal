//
//  Restaurant.swift
//  DealsSortTest
//
//  Created by Angela Smith on 7/22/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class Restaurant: NSObject, Printable, DebugPrintable {
   
    var identifier: String
    var imageName: String
    var name: String
    var address: String
    var distance: Float
    var priceTier: Int
    var phone: String
    var webUrl: String
    var hours: String
    var deal:Deal

    
    init(identifier: String, name: String, phone: String, imageName: String, address: String, hours: String, distance: Float, priceTier: Int, webUrl: String, deal: Deal) {
        self.identifier = identifier
        self.name = name
        self.phone = phone
        self.imageName = imageName
        self.address = address
        self.hours = hours
        self.distance = distance
        self.priceTier = priceTier
        self.webUrl = webUrl
        self.deal = deal
    }

}
