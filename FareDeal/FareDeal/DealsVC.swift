//
//  DealsVC.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/18/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class DealsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dealsList: UITableView!
    var dealsArray = [Deal]()
    let dataManager = DataManager.sharedInstance() // retrives data from core data
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dataManager.getDeals{ results in
            self.dealsArray = results
            self.dealsList.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toDetails" {
            
            var selectedItem:Deal = dealsArray[(dealsList.indexPathForSelectedRow()?.row)!]
            
            let IVC: DealDetailsVC = segue.destinationViewController as! DealDetailsVC
            IVC.tier = selectedItem.tier
            IVC.dealTitle = selectedItem.title
            IVC.desc = selectedItem.desc
            IVC.value = selectedItem.value
            IVC.hours = selectedItem.timeLimit

        }
        
    }
    
    
    @IBAction func onClick(_sender : UIButton?){
        
        if _sender?.tag == 0{
            
            // Publish deals here
            
        }
    }
    

    //Mark# Tableview methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:DealsCell = tableView.dequeueReusableCellWithIdentifier("dealCell") as! DealsCell
        
        // load items from deal array here
        
        cell.refreshCell(dealsArray[indexPath.row].title, desc: dealsArray[indexPath.row].desc, time: dealsArray[indexPath.row].timeLimit, value: "Value: $\(dealsArray[indexPath.row].value)")
        
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
