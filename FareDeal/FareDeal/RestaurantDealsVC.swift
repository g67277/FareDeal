//
//  RestaurantDealsVC.swift
//  FareDeal
//
//  Created by Angela Smith on 7/22/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class RestaurantDealsVC:  UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var deals: [AnyObject] = []
    @IBOutlet weak var tableview: UITableView!
    
    
    
    /* -----------------------  VIEW CONTROLLER  METHODS --------------------------- */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Retrieve the default data from the restaurants plist
        let path = NSBundle.mainBundle().pathForResource("Restaurants", ofType:"plist")
        deals = NSArray(contentsOfFile: path!) as! [Dictionary<String,AnyObject>]
        //println(restaurants.description)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        // Remove text and leave back chevron
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.rowHeight = 217
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* -----------------------  TABLEVIEW  METHODS --------------------------- */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deals.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:RestaurantDealCell = tableView.dequeueReusableCellWithIdentifier("restaurantDealCell") as! RestaurantDealCell
        
        let restaurant: AnyObject = deals[indexPath.row]
        var imageName = restaurant["imageUrl"] as! String
        var locationDeals = restaurant["deals"] as! [AnyObject]
        let restaurantDeal = locationDeals[0] as! [String : AnyObject]
        
        
        cell.setUpCell(restaurant["name"]as! String, phone: restaurant["phone"]as! String, image: UIImage (named: imageName)!, title: restaurantDeal["dealName"] as! String, desc: restaurantDeal["dealDescription"] as! String, time: restaurantDeal["dealTimeLimit"] as! Int, value: restaurantDeal["dealValue"] as! String)
        return cell
    }
    
    /* -----------------------  SEGUE --------------------------- */
    
    // Pass the selected restaurant deal object to the detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "restaurantDealDetailSegue" {
            
            if let indexPath = self.tableview.indexPathForSelectedRow() {
                var restaurant: AnyObject = deals[indexPath.row]
                let destinationVC = segue.destinationViewController as! RestaurantDealDetaislVC
                destinationVC.thisRestaurant = restaurant
                // get the deal for this restaurant
                var locationDeals = restaurant["deals"] as! [AnyObject]
                let restaurantDeal = locationDeals[0] as! [String : AnyObject]
                destinationVC.thisDeal = restaurantDeal
            }
        }
    }
    
    
    
}

