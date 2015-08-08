//
//  ViewController.swift
//  RealmTest
//
//  Created by Nazir Shuqair on 8/1/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    
    var todos = Realm().objects(ToDoItem)
    var realm = Realm()
    var selected = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //println(RLMRealm.defaultRealm().path)
        myTableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(todos.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        

        //let index = UInt(indexPath.row)
        let todoItem = todos[indexPath.row]
        let test:ToDoItem = todos[indexPath.row]
        cell.textLabel!.text = todoItem.name // [5]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        selected = indexPath.row
        performSegueWithIdentifier("toDetails", sender: self)
        
    }
    
    @IBAction func onClick(sender: AnyObject) {
        myTableView.reloadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetails"
        {
            if let sVC = segue.destinationViewController as? AddVC{
                                
                sVC.name = todos[selected].name
                sVC.value = todos[selected].value
                sVC.editingMode = true
                sVC.itemID = todos[selected].id
            }
        }
    }

}

