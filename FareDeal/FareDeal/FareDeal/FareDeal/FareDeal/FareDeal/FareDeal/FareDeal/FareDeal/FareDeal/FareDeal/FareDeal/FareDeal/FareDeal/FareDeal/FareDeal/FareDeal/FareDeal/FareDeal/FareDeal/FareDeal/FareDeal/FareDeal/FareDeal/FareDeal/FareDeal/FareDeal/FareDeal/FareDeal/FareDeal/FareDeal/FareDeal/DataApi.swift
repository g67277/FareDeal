//
//  DataApi.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/19/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class DataApi{
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    public func getData(objectName: String)-> [NSManagedObject]?{
        
        let entityDescription = NSEntityDescription.entityForName(objectName, inManagedObjectContext: managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        
        var objects = managedObjectContext?.executeFetchRequest(request, error: &error)
        
        if let results = objects {
            var objectList = [NSManagedObject]()
            if results.count > 0 {
                for obj in results{
                    let mObj:NSManagedObject = obj as! NSManagedObject
                    objectList.append(mObj)
                }
                return objectList
            } else{
                return nil
            }
        }
        return nil
    }
    
    func updateData<T>(){
        
    }
    
    public func writeLog(log: String){
        var newItem = NSEntityDescription.insertNewObjectForEntityForName("Log", inManagedObjectContext: self.managedObjectContext!) as? NSManagedObject
        
        
        newItem!.setValue(log, forKey: "details")
        newItem!.setValue(NSDate(), forKey: "date")
        var error: NSError?
        
        self.managedObjectContext?.save(&error)
        if let err = error {
            println(err.localizedFailureReason)
        }
    }
    
}

