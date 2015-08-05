//
//  RestaurantDealsVC.swift
//  FareDeal
//
//  Created by Angela Smith on 7/22/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import SwiftyJSON

class RestaurantDealsVC:  UIViewController,  UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    let realm = Realm()
    var plistObjects: [AnyObject] = []
    // get access to all the current deals
    var validDeals = Realm().objects(VenueDeal)
    var haveItems: Bool = false;
    
    // Location objects
    var locationManager : CLLocationManager!
    var venueLocations : [AnyObject] = []
    var venueItems : [[String: AnyObject]]?
    var currentLocation: CLLocation!
    
    
    var topDealReached = false
    var currentDealIndex = 0
    // used in the featured section as to not display non-qualifying deals
    var topBidIndex = 0
    // Holds the last deal processesed for comparison
    var lastDealRestId = ""
    
    var topDeal = VenueDeal()
    let dealList = List<VenueDeal>()

    let defaults = NSUserDefaults.standardUserDefaults()

    
    /* -----------------------  VIEW CONTROLLER  METHODS --------------------------- */
    
    override func viewWillAppear(animated: Bool) {
        // Hide the navigation bar to display the full location image
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = UIImage()
        navBar.backgroundColor = UIColor.clearColor()
        // Start getting the users location
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        // restore the navigation bar to origional
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        navBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = nil
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.rowHeight = 192
        //loadDeals()
        //loadSaloofData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSaloofData () {
        let saloofUrl = NSURL(string: "http://www.justwalkingonwater.com/json/venueResponse.json")!
        let response = NSData(contentsOfURL: saloofUrl)!
        let json: AnyObject? = (NSJSONSerialization.JSONObjectWithData(response,
            options: NSJSONReadingOptions(0),
            error: nil) as! NSDictionary)["response"]
        
        if let object: AnyObject = json {
            haveItems = true
            var groups = object["groups"] as! [AnyObject]
            //  get array of items
            var venues = groups[0]["items"] as! [AnyObject]
            for item in venues {
                // get the venue
                if let venue = item["venue"] as? [String: AnyObject] {
                    // get each deal
                    let venueJson = JSON(venue)
                    // Parse the JSON file using SwiftlyJSON
                    parseJSON(venueJson, source: Constants.sourceTypeSaloof)
                }
            }
            // FINISHED CREATING DATA OBJECTS
            // get a list of all deal objects in Realm
            validDeals = Realm().objects(VenueDeal)
            // Sort all deals by value
            let sortedDeals = Realm().objects(VenueDeal).filter("\(Constants.dealValid) = \(1)").sorted("value", ascending:true)
            validDeals = sortedDeals
            //println("Sorted Deals from ParseJSON \(sortedDeals)")
            biddingStart()
        }
    }
    
    
    
    func parseJSON(json: JSON, source: String) {
        // Create the venue object first
        let venue = Venue()
        venue.identifier = json[Constants.restId].stringValue
        venue.phone = json[Constants.restContactObject][Constants.restContactPhone].stringValue /* Not working*/
        venue.name = json[Constants.restName].stringValue
        venue.webUrl = json[Constants.restUrl].stringValue                       /* Not working*/
        let imagePrefix = json[Constants.restPhotoObject][Constants.restPhotoGroupArray][0][Constants.restPhotoItemsArray][0][Constants.restPhotoPrefix].stringValue
        let imageSuffix = json[Constants.restPhotoObject][Constants.restPhotoGroupArray][0][Constants.restPhotoItemsArray][0][Constants.restPhotoSuffix].stringValue
        let imageName = imagePrefix + "400x400" +  imageSuffix
        var locationAddress = json[Constants.restLocationObject][Constants.restAddressArray][0].stringValue
        var cityAddress = json[Constants.restLocationObject][Constants.restAddressArray][1].stringValue
        venue.address = locationAddress + "\n" + cityAddress
        venue.hours = json[Constants.restHoursObject][Constants.restStats].stringValue
        venue.distance = json[Constants.restLocationObject][Constants.restDistance].floatValue
        venue.priceTier = json[Constants.restPriceObject][Constants.restTier].intValue
        venue.sourceType = source
        venue.swipeValue = 3  // deal only
        venue.favorites = json[Constants.restStats][Constants.restFavorites].intValue
        venue.likes = json[Constants.restStats][Constants.restLikes].intValue
        
        
        // this is a deal only restaurant
        let imageUrl = NSURL(string: imageName)
        if let data = NSData(contentsOfURL: imageUrl!){
            
            let venueImage = UIImage(data: data)
            venue.image = venueImage
        }
        // Then create the deal object and add the venue to it
        if let deals = json[Constants.dealObject][Constants.dealsArray].array {
            for deal in deals {
                let venueDeal = VenueDeal()
                venueDeal.name = deal[Constants.dealTitle].stringValue
                venueDeal.desc = deal[Constants.dealDescription].stringValue
                venueDeal.tier = deal[Constants.dealTier].intValue
                venueDeal.timeLimit = deal[Constants.dealExpires].intValue
                venueDeal.value = deal[Constants.dealValue].floatValue
                venueDeal.venue = venue
                var venueId = "\(venue.identifier).\(venueDeal.tier)"
                venueDeal.id = venueId
                // check for current object
                let realm = Realm()
                // Query using a predicate string
                var dealPreviouslyDisplayed = realm.objectForPrimaryKey(VenueDeal.self, key: venueId)
                if (dealPreviouslyDisplayed != nil) {
                    println("This is a previously pulled deal, checking dates")
                    // we need to check the date
                    let expiresTime = dealPreviouslyDisplayed?.expirationDate
                    // see how much time has lapsed
                    var compareDates: NSComparisonResult = NSDate().compare(expiresTime!)
                    if compareDates == NSComparisonResult.OrderedAscending {
                        // the deal has not expired yet
                        println("This deal is still good")
                    } else {
                        //the deal has expired
                        println("This deal has expired")
                        venueDeal.validValue = 2
                        // update the db
                        realm.write {
                            self.realm.create(VenueDeal.self, value: venueDeal, update: true)
                        }
                    }
                } else {
                    println("This is a new deal, setting expiration date")
                    // set date of expiration
                    let firstLoad = NSDate()
                    // add time based on expiration
                    var time: NSTimeInterval = 0
                    switch deal[Constants.dealExpires].intValue {
                    case 2 :
                        time = 7200
                    case 3 :
                        time = 10800
                    default:
                        time = 3600
                    }
                    println(time)
                    let dealExpires = firstLoad.dateByAddingTimeInterval(time)
                    venueDeal.expirationDate = dealExpires
                    venueDeal.validValue = 1
                    // write to db
                    realm.write {
                        self.realm.create(VenueDeal.self, value: venueDeal, update: true)
                    }
                }
            }
        }
    }
    
    func biddingStart(){
        if currentDealIndex < validDeals.count{
            // we have more deals to sort
            if lastDealRestId != "" {
                
                if lastDealRestId != validDeals[currentDealIndex].venue.identifier {
                    // if the restaurant identifier in the array matches the last restaurant saved, then don't add
                    // restaurant to the dealList because it means the same restaurant is trying to bid it self
                   //println("restaurant id: \(validDeals[currentDealIndex].restId), deal tier: \(validDeals[currentDealIndex].tier), deal value: \(validDeals[currentDealIndex].value)")
                    
                    // Update lastDeal to hold the current restaurant id
                    lastDealRestId = validDeals[currentDealIndex].venue.identifier
                    // Adding the new restaurant to the top of the array as it has a higher value
                    dealList.insert(validDeals[currentDealIndex], atIndex: 0)
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
                //println("restaurant Name: \(validDeals[currentDealIndex].name), deal tier: \(validDeals[currentDealIndex].tier), deal value: \(validDeals[currentDealIndex].value)")
                lastDealRestId = validDeals[currentDealIndex].venue.identifier
                dealList.insert(validDeals[currentDealIndex], atIndex: 0)
                currentDealIndex = currentDealIndex + 1
                delayLoad()
            }
            
        } else {
            
            // Once we are done with the array, hide the indicator, set the topDealReached, display the top
            // deal in the featured section
            topDealReached = true
        }
        
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
        let timeDelay = Double(arc4random_uniform(1500000000) + 300000000)
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(timeDelay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.topDeal = self.validDeals[self.topBidIndex]
            self.tableview.reloadData()
        })
        
    }
    
    /* -----------------------  TABLEVIEW  METHODS --------------------------- */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 310
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dealList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UserDealCell = tableView.dequeueReusableCellWithIdentifier("restaurantDealCell") as! UserDealCell
        
        let deal: VenueDeal = dealList[indexPath.row]
        cell.setUpVenueDeal(deal)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableview.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("dealHeaderCell") as! DealHeaderCell
        headerCell.setUpVenueDeal(topDeal)
        if topDealReached {
            headerCell.activityLabel.text = "This is the best deal in the area! you've just saved $\(String(stringInterpolationSegment: topDeal.value))"
        }
        headerCell.setNeedsDisplay()
        return headerCell
    }

    
    /* -----------------------  SEGUE --------------------------- */
    
    // Pass the selected restaurant deal object to the detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "restaurantDealDetailSegue" {
            
            if let indexPath = self.tableview.indexPathForSelectedRow() {
                let destinationVC = segue.destinationViewController as! RestaurantDealDetaislVC
                // get the deal for this restaurant
                let deal: VenueDeal = dealList[indexPath.row]
                destinationVC.thisDeal = deal
                destinationVC.setUpForSaved = false
            }
        } else if segue.identifier == "restaurantDealDetailSegue2" {
            
            let destinationVC = segue.destinationViewController as! RestaurantDealDetaislVC
            // get the deal for this restaurant
            let deal: VenueDeal = topDeal
            destinationVC.thisDeal = deal
            destinationVC.setUpForSaved = false
        }
    }
    
    // ------------------- USER LOCATION PERMISSION REQUEST  ----------------------
    
    func showErrorAlert(error: NSError) {
        let alertController = UIAlertController(title: "Our Bad!", message:"Sorry, but we are having trouble finding where you are right now. Maybe try agian later.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
        })
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        showErrorAlert(error)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        locationManager.stopUpdatingLocation()
        // if we dont' have any locations, get some
        if haveItems == false {
        // if dealList.count == 0 {
            println("Have location, gather local deals")
            loadSaloofData()
           // pullLocalDeals()
        }
    }
    
    
    
}



