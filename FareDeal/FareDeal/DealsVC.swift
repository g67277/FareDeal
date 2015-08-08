//
//  DealsVC.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/18/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import RealmSwift

class DealsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var dealsList: UITableView!
    
    var dealsArray = Realm().objects(BusinessDeal).sorted("value", ascending: true)
    var realm = Realm()
    var topTier = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var test = dealsArray.count
        if dealsArray.count == 10 {
            addBtn.enabled = false
        }else{
            addBtn.enabled = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false 
    }
    
    override func viewDidAppear(animated: Bool) {
        dealsList.reloadData()
    }
    
    
    func findTopTier(){
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let IVC = segue.destinationViewController as! DealDetailsVC

        if segue.identifier == "toDetails" {
            
            var selectedItem = dealsArray[(dealsList.indexPathForSelectedRow()?.row)!]
            
            IVC.tier = (dealsList.indexPathForSelectedRow()?.row)!
            IVC.dealTitle = selectedItem.title
            IVC.desc = selectedItem.desc
            IVC.value = selectedItem.value
            IVC.hours = selectedItem.timeLimit
            IVC.dealID = selectedItem.id
            IVC.editingMode = true

        }else if segue.identifier == "toAdd"{
            
            
        }
        
    }
    
    
    @IBAction func onClick(_sender : UIButton?){
        
        if _sender?.tag == 0{
            
            // Publish deals here
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Published!"
            alertView.message = "You are now live, get ready for the swarms"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    }
    

    //Mark# Tableview methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:DealsCell = tableView.dequeueReusableCellWithIdentifier("dealCell") as! DealsCell
        
        // load items from deal array here
        
        cell.refreshCell(dealsArray[indexPath.row].title, desc: dealsArray[indexPath.row].desc, time: dealsArray[indexPath.row].timeLimit, value: "$\(dealsArray[indexPath.row].value) value", tier: indexPath.row + 1)
        
        //cell.refreshCell("10% off Drinks", desc: "10% off drinks when you buy anything from the lunch menu", time: 2, value: "Value: $0.80")
        
        return cell
                
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
