//
//  AddVC.swift
//  RealmTest
//
//  Created by Nazir Shuqair on 8/1/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class AddVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    let realm = Realm() // [6.1]
    
    var name = ""
    var value = 0.0
    var editingMode = false
    var itemID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneAction")
        
        textField.text = name
        valueField.text = "\(value)"
        
        var address = "oihoijoi"
        var geocoder = CLGeocoder()
        var test2:CLLocationCoordinate2D = CLLocationCoordinate2D()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                var test:CLLocation = placemark.location
                test2 = test.coordinate
                println("latitute: \(test2.latitude), longitute: \(test2.longitude)")
                }
        })
        println("latitute: \(test2.latitude), longitute: \(test2.longitude)")


    }
    
    @IBAction func deleteItem(sender: AnyObject) {
        
        if itemID != ""{
            var itemToDelete = realm.objectForPrimaryKey(ToDoItem.self, key: itemID)
            
            //        let toDoItem = ToDoItem()
            //        toDoItem.name = name
            //        toDoItem.value = value
            //        toDoItem.id = itemID
            
            realm.write{
                self.realm.delete(itemToDelete!)
            }

        }
        
    }
    func doneAction() { // [6]
        
        if count(textField.text) > 0 {
            let newTodoItem = ToDoItem()
            newTodoItem.name = textField.text
            newTodoItem.value = (valueField.text as NSString).doubleValue
            newTodoItem.finished = true
            if !self.editingMode{
                newTodoItem.id = NSUUID().UUIDString
            }else{
                newTodoItem.id = itemID
            }
            realm.write{
                self.realm.add(newTodoItem, update: self.editingMode)
            }
            
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool { // [8]
        doneAction()
        textField.resignFirstResponder()
        return true
    }
    
}
