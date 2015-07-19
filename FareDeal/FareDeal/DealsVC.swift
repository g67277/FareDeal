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
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        var nib = UINib(nibName: "FareDeal", bundle: nil)
//        dealsList.registerNib(nib, forCellReuseIdentifier: "DealsCell")
        
    }

    
    
    @IBAction func onClick(_sender : UIButton?){
        
        if _sender?.tag == 0{
            
            // Publish deals here
            
        }
    }
    

    //Mark# Tableview methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:DealsCell = tableView.dequeueReusableCellWithIdentifier("dealCell") as! DealsCell
        
        // load items from deal array here
        
        cell.refreshCell("10% off Drinks", desc: "10% off drinks when you buy anything from the lunch menu", time: 2, value: "Value: $0.80")
        
        return cell
                
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
