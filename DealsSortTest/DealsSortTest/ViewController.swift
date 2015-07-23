//
//  ViewController.swift
//  DealsSortTest
//
//  Created by Angela Smith on 7/22/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var dealTable: UITableView!
    @IBOutlet var dealNameLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var activityLabel: UILabel!
    var plistObjects: [AnyObject] = []
    
    @IBOutlet var dealValueLabel: UILabel!
    var dealList: [Deal] = []
    var topValue:Float = 0
    var topHighestTier:Int = 1
    var currentTier:Int = 1
    var currentRestaurantIndex:Int = 0
    
    var topDeal : Deal?
    
    var allRestaurants: [Restaurant] = []
    var dealListRestaurants: [Restaurant] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // load the data
        loadDeals()
    }

    /* --------  LOAD RESTAURANT OBJECTS WITH THEIR DEALS FROM PLIST (LATER API) ------------------ */
    
    // pull in the deals for the retrieving restaurants
    func loadDeals() {
        activityIndicator.startAnimating()
        activityLabel.hidden = false
        // get data (from plist)
        let path = NSBundle.mainBundle().pathForResource("RestaurantData", ofType:"plist")
        plistObjects = NSArray(contentsOfFile: path!) as! [Dictionary<String,AnyObject>]
        
        // loop through the objects and create restaurant and deal objects
        for object: AnyObject in plistObjects {
            var deals: [Deal] = []
            // Get the array of deals
            var dealsObjects = object[Constants.dealsArray] as! [AnyObject]
            // loop through the deals
            for eachDeal: AnyObject in dealsObjects {
                // create a deal object
                var deal = Deal(
                    name: eachDeal[Constants.dealTitle] as! String,
                    desc: eachDeal[Constants.dealDescription] as! String,
                    timeLimit: eachDeal[Constants.dealExpires] as! Int,
                    tier: eachDeal[Constants.dealTier] as! Int,
                    value: eachDeal[Constants.dealValue] as! Float,
                    isDefault: eachDeal[Constants.dealIsDefault] as! Bool,
                    restId: object[Constants.restId] as! String)
                // save this object to the deal array
                deals.append(deal)
            }
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
                deals: deals)
            // add the restaurant to the restaurant array
            allRestaurants.append(restaurant)
        }
        // start out the list of restaurants to search with all restaurants
        dealListRestaurants = allRestaurants
        // get the highest tier level to make sure we don't continuously run through tiers without competitors
        calculateHighestTier()
        // once done, get the first deal
        getFirstDeal()
    }
    
    /* -----------------------  CALCULATE THE HIGHEST TIER FOR THE DEALS AVAILABLE  --------------------------- */
    func calculateHighestTier() {
        // loop through the restaurants and create an array of tier levels
        var tierArray: [Int] = []
        for restaurant: Restaurant in allRestaurants {
            let restaurantDeals = restaurant.deals
            var tierLevels: [Int] = []
            for deal: Deal in restaurantDeals {
                tierLevels.append(deal.tier)
            }
            // then get the max tier and add to the tier array
            tierArray.append(maxElement(tierLevels))
            println("Tier levels \(tierLevels)")
        }
        // once done sort the array
        tierArray.sort {
            return $0 < $1
        }
        // remove the last value in case it was the only deal in that tier
        tierArray.removeLast()
        // set our highest tier as the value that has at least 2 deals
        topHighestTier = maxElement(tierArray)
        println("Highest matching Tier \(topHighestTier)")
    }
    
    
      /* -----------------------  DELAY  METHODS --------------------------- */
    
    // This method creates a break between the tableview updating and returning a new deal to add to the view
    func delayLoad() {
        let timeDelay = Double(arc4random_uniform(5) + 2)
        let delay: Double = timeDelay * Double(NSEC_PER_SEC)
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.getNextDeal()
            
        })
    
    }
    
    // This delay starts the spinner giving the appearance a new deal is loading, then removes it and updates the list with a new deal
    func delayReload() {
        self.activityIndicator.startAnimating()
        self.activityLabel.hidden = false
        let timeDelay = Double(arc4random_uniform(5) + 2)
        let delay: Double = timeDelay * Double(NSEC_PER_SEC)
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.reloadTableView()
        })
    
    }
    
      /* -----------------------  GETS FIRST OR NEW DEALS FOR TABLEVIEW  --------------------------- */
    
    func getFirstDeal() {
        println("Users: Deals: getting first deal")
        // get first restaurant
        let firstR: Restaurant = dealListRestaurants[0]
        //get their deals
        let firstD: Deal = firstR.deals[0]
        // Set the top deal
        topDeal = firstD
        topValue = firstD.value
        setTopDeal()
        currentRestaurantIndex = currentRestaurantIndex + 1
        getNextDeal()
    }
    
    // Main method, checks the index of the restaurant in the restaurant array, if equal to the current index that means we need to move up a tier, and reset the restaurant index back to 0 to start searching through all restaurants again
    func getNextDeal() {

        println("Deal list restaurants count: \(dealListRestaurants.count)")
        println("All restaurants count: \(allRestaurants.count)")
        if currentRestaurantIndex == dealListRestaurants.count {
            println("Users: Deals: reached last restaurant, updating tier and resetting index")
            ++currentTier
            currentRestaurantIndex = 0
        }
        // Once we are looking in the right restaurant and tier, we make sure this restaurant isn't the same as the top tier. If it is we skip it, if not we search for the deal that matches the current tier. If one isn't found, that restaurant is removed from the list of restaurants to search through as there are no greater deals left to add.
        var restaurant = dealListRestaurants[currentRestaurantIndex]
        // make sure the id does not match the top deal id
        if (restaurant.identifier != topDeal?.restId) {
            println("Users: Deals: not top deal restaurant, getting deals")
            // get the array of deals
            let restaurantDeals = restaurant.deals
            // look for a deal with the matching tier level
            if self.currentTier <= topHighestTier {
                if let found = find(lazy(restaurantDeals).map({ $0.tier == self.currentTier }), true) {
                    let deal: Deal = restaurantDeals[found]
                    // Once a deal is found it is checked to see if the value is greater than the current top tier. If it is, the current top tier is added to the list, and this one replaces it. If not, this deal is added to the list.
                    println("Users: Deals: Found a deal matching current tier")
                    // check the value
                    if deal.value > topValue {
                        println("Users: Deals: current deal has greater value than top, switching")
                        // we need to move the current top deal to the list and set this as the new top
                        dealList.append(topDeal!)
                        topDeal = deal
                        setTopDeal()
                        delayReload()
                        currentRestaurantIndex = currentRestaurantIndex + 1
                        delayLoad()
                    } else {
                        println("Users: Deals: Current deal lower value than top, adding to list")
                        // just add this to the list and restart the process
                        dealList.append(deal)
                        println("Deals: \(dealList.count)")
                        delayReload()
                        currentRestaurantIndex = currentRestaurantIndex + 1
                        delayLoad()
                    }
                } else { // a deal was not found with a matching tier for this restaurant
                    println("Users: Deals: no matching deal with the current tier found, removing restaurant from search")
                    dealListRestaurants.removeAtIndex(currentRestaurantIndex)
                    delayLoad()
                  
                }
            }
        } else {
            println("Users: Deals: getting next deal and restaurant matches, skipping to restaurant index \(currentRestaurantIndex)")
            ++currentRestaurantIndex
            delayLoad()
        }

    }
    
    // Method that stops the annimation and reloads the tableview (called after a delay)
    func reloadTableView() {
        self.activityIndicator.stopAnimating()
        self.activityLabel.hidden = true
        self.dealTable.reloadData()
    }
    
    
    // Method that sets the header view details with the current top deal
    func setTopDeal() {
         println("Users: Deals: setting top deal")
        dealNameLabel.text = topDeal?.name
        dealValueLabel.text = "Value: \(topDeal?.value)"
    }
    
    
    
    /* -----------------------  TABLEVIEW  METHODS --------------------------- */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dealList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("dealCell") as! UITableViewCell
        
        let deal: Deal = dealList[indexPath.row]
        var dealName =  deal.name as String
        var dealValue = deal.value as Float
        cell.textLabel?.text = deal.name
        cell.detailTextLabel?.text = "Value: \(deal.value)"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

