//
//  DataManager.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/19/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class DataManager {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let dataApi = DataApi()

    // Get Deals from Core Data -- temporary, will be replaced by web calls later
    public func getDeals(completion: [Deal]->()){
        var dealObj = dataApi.getData("Deal")
        var deals = [Deal]()
        if dealObj != nil {
            
            for dealObj in dealObj!{
                var deal = Deal()
                deal.tier = dealObj.valueForKey("tier") as! Int
                deal.title = dealObj.valueForKey("title") as! String
                deal.desc = dealObj.valueForKey("dealDesc") as! String
                deal.timeLimit = dealObj.valueForKey("timeLimit") as! Int
                deal.value = dealObj.valueForKey("value") as! Double
                deals.append(deal)
            }
            completion(deals)
            
        }else{
            
            // No deals exist in locally.
            debugPrintln("Nothing here!")

        }
    }
    
    public func saveDeals(deal : Deal, completion: Bool ->()){
        
        var newItem = NSEntityDescription.insertNewObjectForEntityForName("Deal", inManagedObjectContext: self.managedObjectContext!) as? NSManagedObject
        
        newItem!.setValue(deal.tier, forKey: "tier")
        newItem!.setValue(deal.title, forKey: "title")
        newItem!.setValue(deal.desc, forKey: "dealDesc")
        newItem!.setValue(deal.timeLimit, forKey: "timeLimit")
        newItem!.setValue(deal.value, forKey: "value")

        var error: NSError?
        
        self.managedObjectContext?.save(&error)
        debugPrintln("new Deal saved")
        
        if let err = error{
            debugPrintln(err.localizedFailureReason)
            self.dataApi.writeLog(err.localizedFailureReason!)
        }
        
        completion(true)
    
    }
    
    public class func sharedInstance() -> DataManager! {
    
        struct Static {
            static var instance: DataManager? = nil
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = self()
        }
        
        return Static.instance!
    }
    
    required public init() {
        debugPrintln("DataManager instance created");
    }
    
}