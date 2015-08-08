//
//  ViewController.swift
//  RealmDeals
//
//  Created by Angela Smith on 7/27/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var activityLabel: UILabel!
    

    var plistObjects: [AnyObject] = []
    var allDeals = Realm().objects(Deal)
    var allRestaurants = Realm().objects(Restaurant)
    
    
    var topDealReached = false
    var currentDealIndex = 0
    // used in the featured section as to not display non-qualifying deals
    var topBidIndex = 0
    // Holds the last deal processesed for comparison
    var lastDealRestId = ""
    
    var topDeal: Deal
    let dealList = List<Deal>()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.rowHeight = 217
        loadDeals()
    }
    
    func loadDeals(){
        if allRestaurants.count == 0 {
            println("Saving objects to Realm")
            // we have not saved any Restaurants with Realm yet, load them
            let path = NSBundle.mainBundle().pathForResource("RestaurantData", ofType:"plist")
            plistObjects = NSArray(contentsOfFile: path!) as! [Dictionary<String,AnyObject>]
            
            // If we want to persist this to disk
            let realm = Realm()
            
            // If we want to only save to temporary memory (deals)
            //let realm = Realm(inMemoryIdentifier: "DealMemoryRealm")
            
            // Creates a restaurant object for each deal...
            for object: AnyObject in plistObjects {
                // Start the realm restaurant object
                let newRestaurant = Restaurant()
                newRestaurant.identifier = object[Constants.restId] as! String
                newRestaurant.name = object[Constants.restName] as! String
                newRestaurant.phone = object[Constants.restContactPhone]  as! String
                newRestaurant.imageName = object[Constants.restImageName]  as! String
                newRestaurant.address = object[Constants.restAddressArray] as! String
                newRestaurant.hours = object[Constants.restStatus]  as! String
                newRestaurant.distance = object[Constants.restDistance] as! Float
                newRestaurant.priceTier = object[Constants.restTier]as! Int
                newRestaurant.webUrl = object[Constants.restUrl]  as! String

                // get the array of deals
                var restaurantDeals = object[Constants.dealsArray]  as! [Dictionary<String,AnyObject>]
                for eachDeal: AnyObject in restaurantDeals {
                    // Create deal objects
                    let newDeal = Deal()
                    newDeal.name = eachDeal[Constants.dealTitle] as! String
                    newDeal.desc = eachDeal[Constants.dealDescription] as! String
                    newDeal.timeLimit = eachDeal[Constants.dealExpires] as! Int
                    newDeal.tier = eachDeal[Constants.dealTier] as! Int
                    newDeal.value = eachDeal[Constants.dealValue] as! Float
                    newDeal.isDefault = eachDeal[Constants.dealIsDefault] as! Bool
                    newDeal.restId = object[Constants.restId] as! String
                    newDeal.dealId = eachDeal[Constants.dealID] as! String
                    // add the deal to this restaurants deal array
                    newRestaurant.deals.append(newDeal)
                }
                // Finally, write this whole restaurant object to Realm
                realm.write {
                    realm.add(newRestaurant)
                }
            }
        } else {
            println("Objects already saved to Realm")
        }
        // FINISHED CREATING DATA OBJECTS
        // get a list of all restaurant objects in Realm
        allRestaurants = Realm().objects(Restaurant)
        println(allRestaurants)
        
        // Get a list of all deal objects in the realm database presorted by deal value
       let sortedDeals = Realm().objects(Deal).sorted("value", ascending:true)
        allDeals = sortedDeals
        println(sortedDeals)
        
        biddingStart()
    }
    
    
    func biddingStart(){
        if currentDealIndex < allDeals.count{
            // we have more deals to sort
            if lastDealRestId != "" {
                
                if lastDealRestId != allDeals[currentDealIndex].restId {
                    // if the restaurant identifier in the array matches the last restaurant saved, then don't add
                    // restaurant to the dealList because it means the same restaurant is trying to bid it self
                    println("restaurant id: \(allDeals[currentDealIndex].restId), deal tier: \(allDeals[currentDealIndex].tier), deal value: \(allDeals[currentDealIndex].value)")
                    
                    // Update lastDeal to hold the current restaurant id
                    lastDealRestId = allDeals[currentDealIndex].restId
                    // Adding the new restaurant to the top of the array as it has a higher value
                    dealList.insert(allDeals[currentDealIndex], atIndex: 0)
                    delayReload()
                    // match the topBidIndex with current RestaurantIndex... This only happenes here.
                    topBidIndex = currentDealIndex
                    currentDealIndex = currentDealIndex + 1
                    
                    delayLoad()
                }else{
                    // increment current index to skip this deal, topBid is not updated so that we don't display this
                    // bad deal in the featured section
                    currentDealIndex = currentDealIndex + 1
                    biddingStart()
                }

            }else{
                println("restaurant Name: \(allDeals[currentDealIndex].name), deal tier: \(allDeals[currentDealIndex].tier), deal value: \(allDeals[currentDealIndex].value)")
                lastDealRestId = allDeals[currentDealIndex].restId
                dealList.insert(allDeals[currentDealIndex], atIndex: 0)
                currentDealIndex = currentDealIndex + 1
                
                displayFeaturedDeal(allDeals[currentDealIndex])
                delayLoad()
            }
            
        }else{
            
            // Once we are done with the array, hide the indicator, set the topDealReached, display the top
            // deal in the featured section and update the text in the activityLabel
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
            topDealReached = true
            displayFeaturedDeal(allDeals[currentDealIndex])
            
        }
        
    }
    
    func displayFeaturedDeal(deal: Deal){
        
        descLabel.text = deal.desc
        // reformat the float to display a monetary value
        let valueFloat:Float = deal.value, valueFormat = ".2"
        valueLabel.text = "Value: $\(valueFloat.format(valueFormat))"
        
        if topDealReached {
            activityLabel.text = "This is the best deal in the area! you've just saved $\(String(stringInterpolationSegment: deal.value))"
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
            self.displayFeaturedDeal(self.allDeals[self.topBidIndex])
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
        
        let deal: Deal = dealList[indexPath.row]
        let restaurantID = deal.restId
        let restaurant: Restaurant = Realm.objects(Restaurant).filter("identifier = " = restaurantID)
        cell.setUpRestaurantDeal(restaurant, deal: deal)
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

