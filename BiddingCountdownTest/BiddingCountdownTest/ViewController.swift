//
//  ViewController.swift
//  BiddingCountdownTest
//
//  Created by Angela Smith on 7/25/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var activityLabel: UILabel!
    
    
    var plistObjects: [AnyObject] = []
    // Holds all the restaurants
    var allRestaurants: [Restaurant] = []
    // Holds all the restaurants/Deals to be displayed
    var dealList: [Restaurant] = []
    
    var topDealReached = false
    var currentRestaurantIndex = 0
    // used in the featured section as to not display non-qualifying deals
    var topBidIndex = 0
    // Holds the last deal processesed for comparison
    var lastDeal:Restaurant!
    
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        // reset default
       // defaults.removeObjectForKey(Constants.dealDefaults)
        super.viewDidLoad()
        let firstDate = NSDate()
        println(firstDate)
        myTableView.rowHeight = 217
        loadDeals()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    func loadDeals(){
        
        let path = NSBundle.mainBundle().pathForResource("RestaurantData", ofType:"plist")
        plistObjects = NSArray(contentsOfFile: path!) as! [Dictionary<String,AnyObject>]
        
        var dealsNRestaurants : [Restaurant] = []
        
        // Creates a restaurant object for each deal...
        for object: AnyObject in plistObjects{
            
            var dealsObjects = object[Constants.dealsArray] as! [AnyObject]
            
            for eachDeal: AnyObject in dealsObjects {
                
                var deal = Deal(
                    name: eachDeal[Constants.dealTitle] as! String,
                    desc: eachDeal[Constants.dealDescription] as! String,
                    timeLimit: eachDeal[Constants.dealExpires] as! Int,
                    tier: eachDeal[Constants.dealTier] as! Int,
                    value: eachDeal[Constants.dealValue] as! Float,
                    isDefault: eachDeal[Constants.dealIsDefault] as! Bool,
                    restId: object[Constants.restId] as! String,
                    dealId: eachDeal[Constants.dealID] as! String)
                    // CHECK IF DEAL ALREADY LOADED
                    checkDeal(deal.dealId)
                
                // then create the restaurant object
                var restaurant = Restaurant(
                    identifier: object[Constants.restId] as! String,
                    name: object[Constants.restName] as! String,
                    phone: object[Constants.restContactPhone]  as! String,
                    imageName: object[Constants.restImageName]  as! String,
                    address: object[Constants.restAddressArray] as! String,
                    hours: object[Constants.restStatus]  as! String,
                    distance: object[Constants.restDistance] as! Float,
                    priceTier: object[Constants.restTier]as! Int,
                    webUrl: object[Constants.restUrl]  as! String,
                    deal: deal)
                // add the restaurant to the restaurant array
                allRestaurants.append(restaurant)
            }
            
            // start out the list of restaurants to search with all restaurants
            
        }
        
        // Sorts all the restaurants by the deal they contain
        allRestaurants.sort({$0.deal.value < $1.deal.value})
        
        biddingStart()
    }
    
    
    func biddingStart(){
        if currentRestaurantIndex < allRestaurants.count{
            
            // Checks if this is the first time this method is run
            if lastDeal != nil {
                
                // if the restaurant identifier in the array matches the last restaurant saved, then don't add
                // restaurant to the dealList because it means the same restaurant is trying to bid it self
                if allRestaurants[currentRestaurantIndex].identifier != lastDeal.identifier {
                    
                    println("restaurant id: \(allRestaurants[currentRestaurantIndex].identifier), deal tier: \(allRestaurants[currentRestaurantIndex].deal.tier), deal value: \(allRestaurants[currentRestaurantIndex].deal.value)")
                   
                    
                    // Update lastDeal to hold the current restaurant
                    lastDeal = allRestaurants[currentRestaurantIndex]
                    // Adding the new restaurant to the top of the array as it has a higher value
                    dealList.insert(allRestaurants[currentRestaurantIndex], atIndex: 0)
                    delayReload()
                    // match the topBidIndex with current RestaurantIndex... This only happenes here.
                    topBidIndex = currentRestaurantIndex
                    currentRestaurantIndex = currentRestaurantIndex + 1
                    
                    delayLoad()
                }else{
                    // increment current index to skip this deal, topBid is not updated so that we don't display this
                    // bad deal in the featured section
                    currentRestaurantIndex = currentRestaurantIndex + 1
                    biddingStart()
                }
                
            }else{
                println("restaurant Name: \(allRestaurants[currentRestaurantIndex].name), deal tier: \(allRestaurants[currentRestaurantIndex].deal.tier), deal value: \(allRestaurants[currentRestaurantIndex].deal.value)")
                lastDeal = allRestaurants[currentRestaurantIndex]
                dealList.insert(allRestaurants[currentRestaurantIndex], atIndex: 0)
                currentRestaurantIndex = currentRestaurantIndex + 1
                
                displayFeaturedDeal(allRestaurants[currentRestaurantIndex])
                delayLoad()
            }
            
        }else{
            
            // Once we are done with the array, hide the indicator, set the topDealReached, display the top
            // deal in the featured section and update the text in the activityLabel
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
            topDealReached = true
            displayFeaturedDeal(allRestaurants[topBidIndex])
            
        }
        
    }
    
    func displayFeaturedDeal(restaurant: Restaurant){
        
        descLabel.text = restaurant.deal.desc
        // reformat the float to display a monetary value
        let valueFloat:Float = restaurant.deal.value, valueFormat = ".2"
        valueLabel.text = "Value: $\(valueFloat.format(valueFormat))"
        
        if topDealReached {
            activityLabel.text = "This is the best deal in the area! you've just saved $\(String(stringInterpolationSegment: restaurant.deal.value))"
        }
        
    }
    
     /* -----------------------  CHECK IF DEAL WAS PREVIOUSLY DISPLAYED  --------------------------- */
    
    func checkDeal(dealId: String){
        // load any deals stored in nsuser defaults
        if (NSUserDefaults.standardUserDefaults().objectForKey(Constants.dealDefaults) != nil) {
            // we have saved data
            var arrayOfDealObjects = defaults.objectForKey(Constants.dealDefaults) as! [Dictionary<String,String>]
            // search through the objects
            var found = false
            for deal: [String: String] in arrayOfDealObjects {
                // If we have this deal, get the time
                if let timeStarted = deal[dealId] {
                    println("Found deal: \(dealId) in defaults: \(timeStarted)")
                    found = true
                }
            }
            if !found {
                println("Did not find deal: \(dealId), creating a new one")
                // add this to the list
                saveDealIdInDefaults(dealId, dealObjects: arrayOfDealObjects)
            }
        } else {
           // save the first one
            var arrayOfDealObjects: [Dictionary<String,String>] = []
            saveDealIdInDefaults(dealId, dealObjects: arrayOfDealObjects)
        }
        

    }
    
    func saveDealIdInDefaults(dealId: String, dealObjects: [Dictionary<String,String>]) {
         var arrayOfDealObjects = dealObjects
        // it doen't exist yet, save it
        let date = NSDate();
        // add formatter to include seconds
        var formatter = NSDateFormatter();
        formatter.dateFormat = Constants.dealDateFormatter;
        let completedateTime = formatter.stringFromDate(date);
        // add this deal to array of deal objects
        let newDealDictionary = [dealId:completedateTime]
        arrayOfDealObjects.append(newDealDictionary)
        // resave this to defaults
        println("Saving deal: \(dealId) to defaults. Total deals saved: \(arrayOfDealObjects.count)")
        defaults.setObject(arrayOfDealObjects, forKey: Constants.dealDefaults)
        defaults.synchronize()
    
    }
    
    /* -----------------------  DELAY  METHODS --------------------------- */
    
    // This method creates a break between the tableview updating and returning a new deal to add to the view
    func delayLoad() {
        let timeDelay = Double(arc4random_uniform(1500000000) + 100000000)
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(timeDelay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.biddingStart()
            
        })
        
    }
    
    // This delay starts the spinner giving the appearance a new deal is loading, then removes it and updates the list with a new deal
    func delayReload() {
        self.activityIndicator.startAnimating()
        self.activityLabel.hidden = false
        let timeDelay = Double(arc4random_uniform(1500000000) + 300000000)
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(timeDelay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.displayFeaturedDeal(self.allRestaurants[self.topBidIndex])
            self.myTableView.reloadData()
        })
        
    }
    
    /* -----------------------  TABLEVIEW  METHODS --------------------------- */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dealList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:RestaurantDealCell = tableView.dequeueReusableCellWithIdentifier("restaurantDealCell") as! RestaurantDealCell
        
        let restaurant: Restaurant = dealList[indexPath.row]
        let restaurantDeal = restaurant.deal
        cell.setUpRestaurantDeal(restaurant, deal: restaurantDeal)
        return cell

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


