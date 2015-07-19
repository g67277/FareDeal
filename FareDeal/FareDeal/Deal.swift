//
//  Deal.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/18/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

import CoreData

public struct Deal: Serializable {
    
    var title = ""
    var desc = ""
    var timeLimit = 0
    var value = 0.0
    
    init(dictionary: [NSObject: AnyObject]) {
        
        
        if let titleObject: AnyObject = dictionary["Title"] {
            if let identifierString = titleObject as? String {
                self.title = identifierString
            }
        }
        
        if let descObject: AnyObject = dictionary["Description"] {
            if let identifierString = descObject as? String {
                self.desc = identifierString
            }
        }
        
        if let timeLimitObject: AnyObject = dictionary["TimeLimit"]{
            if let identifierInt = timeLimitObject as? Int{
                self.timeLimit = identifierInt
            }
        }
        
        if let valueObject: AnyObject = dictionary["value"]{
            if let identifierDouble = valueObject as? Double {
                self.value = identifierDouble
            }
        }
                
    }
    init(){
        
    }
}

protocol Serializable {
    init(dictionary: [NSObject: AnyObject])
}
