//
//  ViewController.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/15/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class BusinessHome: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var creditBalanceLabel: UILabel!
    @IBOutlet weak var dealsSelectedLabel: UILabel!
    @IBOutlet weak var dealsSwapedLabel: UILabel!
    @IBOutlet weak var monthSelector: UITableView!
    @IBOutlet weak var monthsBtn: UIButton!
    
    // holds all the months to display in selector
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let titleFont:UIFont = UIFont(name: "Middlecase Regular-Inline.otf", size: 20)!
//        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: titleFont]
        
        
        let date = NSDate();
        var formatter = NSDateFormatter();
        formatter.dateFormat = "MMMM";
        let defaultTimeZoneStr = formatter.stringFromDate(date);
        monthsBtn.setTitle(defaultTimeZoneStr, forState: UIControlState.Normal)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let creditsAvailable:Int = prefs.integerForKey("credits") as Int
        
        if creditsAvailable > 0 {
            creditBalanceLabel.text = "\(creditsAvailable)C"
        }else{
            creditBalanceLabel.text = "No Credits"
        }
    }
    
    @IBAction func onClick(_sender : UIButton?){
        
        if _sender?.tag == 1{
            
            monthSelector.hidden = false
            
        }else if _sender?.tag == 2{
            
            // View deals here
            
            println("add")
            
        }else if _sender?.tag == 3{
            
            // Edit profile here
            println("add")
            
        }
    }
    
    
    //Mark# Tableview methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = months[indexPath.row]
        cell.textLabel?.textColor = .whiteColor()
        cell.textLabel?.font = UIFont(name: "Avenir Medium", size: 12)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        monthsBtn.setTitle(months[indexPath.row], forState: UIControlState.Normal)
        updateAnalytics()
        monthSelector.hidden = true
        
    }
    
    func updateAnalytics(){
        
        //Update numbers here
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toProfile") {
            var svc = segue.destinationViewController as! RegisterRestaurantVC2;
            
            svc.profileView = true
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

