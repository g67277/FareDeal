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

class RestaurantDealsVC:  UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // View properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var bestButton: UIButton!
    @IBOutlet var oldestButton: UIButton!
    @IBOutlet var collectionCardView: UIView!
    @IBOutlet var singleDealView: UIView!
    @IBOutlet var pageController: UIPageControl!
    
    @IBOutlet var saveSwapButton: UIButton!
    
    // singleDealOutlets
    @IBOutlet weak var singleLocationTitle: UILabel!
    @IBOutlet weak var singleLocationImage: UIImageView!
    @IBOutlet weak var singleDealTitle: UILabel!
    @IBOutlet weak var singleDealDesc: UILabel!
    @IBOutlet weak var singleDealValue: UILabel!

    @IBOutlet var cardButtonsView: UIView!
    
    // top deal timer
    @IBOutlet weak var timeLimitLabel: TTCounterLabel!
    let realm = Realm()
    var plistObjects: [AnyObject] = []
    // get access to all the current deals
    var validDeals = Realm().objects(VenueDeal)
    var haveItems: Bool = false;
    var loadSingleDeal: Bool = false
    // Location objects
    var locationManager : CLLocationManager!
    var venueLocations : [AnyObject] = []
    var venueItems : [[String: AnyObject]]?
    var currentLocation: CLLocation!
    
    var setUpForSaved: Bool = false
    var setUpForDefault: Bool = false
    var topDealReached = false
    var currentDealIndex = 0
    // used in the featured section as to not display non-qualifying deals
    var topBidIndex = 0
    // Holds the last deal processesed for comparison
    var lastDealRestId = ""
    var currentSavedDealId = ""
    var singleDeal = VenueDeal()
    var savedDeal = SavedDeal()
    var topDeal = VenueDeal()
    var selectedDeal: VenueDeal?
    let dealList = List<VenueDeal>()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    /* -----------------------  VIEW CONTROLLER  METHODS --------------------------- */
    
    override func viewWillAppear(animated: Bool) {
        // Hide the navigation bar to display the full location image
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        if navBar != nil{
            navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navBar.shadowImage = UIImage()
            navBar.backgroundColor = UIColor.clearColor()
        }
        // delete expired deals
        var expiredDeals = Realm().objects(VenueDeal).filter("\(Constants.dealValid) = \(2)")
        realm.write {
            self.realm.delete(expiredDeals)
        }
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        // restore the navigation bar to origional
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        if navBar != nil{
            navBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
            navBar.shadowImage = nil
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if loadSingleDeal {
            
            // Set up view for a single deal
            collectionCardView.hidden = true
            cardButtonsView.hidden = true
            singleDealView.hidden = false
            
            // see if it is for the saved deal or a default deal
            if setUpForSaved {
                setUpSaveSwapButton()
                saveSwapButton.enabled = false
            }
            else if setUpForDefault {
                setUpDefaultDeal()
            }
        } else {
            // start getting new deals for collection view
            singleDealView.hidden = true
            collectionCardView.hidden = false
            cardButtonsView.hidden = false
            // Start getting the users location
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }

    }
    
    func setButtonTitle (title: String) {
        saveSwapButton.setTitle(title, forState: UIControlState.Normal)
        saveSwapButton.setTitle(title, forState: UIControlState.Selected)
    }

    
    func setUpDefaultDeal() {
        // set up view for a default deal
        singleLocationTitle.text = " from \(singleDeal.venue.name)"
        if singleDeal.venue.hasImage {
            singleLocationImage.image = singleDeal.venue.image
        } else {
            // set up default image
            singleLocationImage.image = UIImage(named: "redHen")
        }
        singleDealTitle.text = singleDeal.name
        singleDealDesc.text = singleDeal.desc
        // Set up the value
        let valueFloat:Float = singleDeal.value, valueFormat = ".2"
        singleDealValue.text = "$\(valueFloat.format(valueFormat)) value"
    }
    
    func setUpSaveSwapButton () {
        // set up view for a default deal
        singleLocationTitle.text = " from \(savedDeal.venue.name)"
        if savedDeal.venue.hasImage {
            singleLocationImage.image = savedDeal.venue.image
        } else {
            // set up default image
            singleLocationImage.image = UIImage(named: "redHen")
        }
        singleDealTitle.text = savedDeal.name
        singleDealDesc.text = savedDeal.desc
        // Set up the value
        let valueFloat:Float = savedDeal.value, valueFormat = ".2"
        singleDealValue.text = "$\(valueFloat.format(valueFormat)) value"
        setSavedDealTimer(savedDeal)
    }
    
   
    @IBAction func userPressedSaveSwapButton(sender: UIButton) {
        
        // if viewing non current saved deal, see if we have a saved one
        checkForPreviouslySavedDeal()
        
    }
    
   func checkForPreviouslySavedDeal() {
        // check if user already has a saved deal
        var currentSavedDeal = realm.objects(SavedDeal).first
        if (currentSavedDeal != nil) {
            println("The user has a saved deal")
            // make sure the deal is not expired
            let valid = checkDealIsValid(currentSavedDeal!)
            if valid {
                println("The user has a saved deal")
                // display an alert requesting if they want to switch
                let alertController = UIAlertController(title: "Swap Deals?", message: "Would you like to swap \(currentSavedDeal?.name) for \(selectedDeal?.name)", preferredStyle: .Alert)
                // Add button action to swap
                let cancelSwap = UIAlertAction(title: "Cancel", style: .Default, handler: {
                    (action) -> Void in
                })
                let swapDeals = UIAlertAction(title: "Swap", style: .Default, handler: {
                    (action) -> Void in
                    // Swap deals
                    self.realm.write {
                        self.realm.delete(currentSavedDeal!)
                    }
                    self.saveNewDeal()
                })
                alertController.addAction(cancelSwap)
                alertController.addAction(swapDeals)
                presentViewController(alertController, animated: true, completion: nil)
            } else {
                // deleted old deal, save new one
                realm.write {
                    self.realm.delete(currentSavedDeal!)
                }
                println("Deleted expired deal and saving new one")
                // save this deal as the saved deal
                saveNewDeal()
            }
        } else {
            println("Setting a new saved deal")
            // save this deal as the saved deal
            saveNewDeal()
        }
    }
    
    func checkDealIsValid (savedDeal: SavedDeal) -> Bool {
        // we need to check the date
        let expiresTime = savedDeal.expirationDate
        // see how much time has lapsed
        var compareDates: NSComparisonResult = NSDate().compare(expiresTime)
        if compareDates == NSComparisonResult.OrderedAscending {
            // the deal has not expired yet
            println("This deal is still good")
            return true
        } else {
            //the deal has expired
            println("This deal has expired, deleting it")
            realm.write {
                self.realm.delete(savedDeal)
            }
            return false
        }
    }
    
    func saveNewDeal () {
        if let deal: VenueDeal = selectedDeal {
            currentSavedDealId = deal.id
            let newDeal = SavedDeal()
            newDeal.name = deal.name
            newDeal.desc = deal.desc
            newDeal.tier = deal.tier
            newDeal.timeLimit = deal.timeLimit
            newDeal.expirationDate = deal.expirationDate
            newDeal.value = deal.value
            newDeal.venue = deal.venue
            var venueId = "\(newDeal.venue.identifier).\(newDeal.tier)"
            newDeal.id = venueId
            realm.write {
                self.realm.create(SavedDeal.self, value: newDeal, update: true)
            }
            // alert user deal was saved
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Deal Saved!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            // and change the button
            saveSwapButton.enabled = false
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButtonSelect(sender: UIButton) {
        if sender.tag == 0 {
            bestButton.selected = true
            oldestButton.selected = false
            pageController.currentPage = 0
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            let deal: VenueDeal = dealList[indexPath.row]
            // set the timer to this deal
            setDealTimer(deal)

        }  else if sender.tag == 2 {
            bestButton.selected = false
            oldestButton.selected = true
            println(pageController.currentPage)
            pageController.currentPage = dealList.count - 1
            let indexPath = NSIndexPath(forRow: Int(dealList.count-1), inSection: 0)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            let deal: VenueDeal = dealList[indexPath.row]
            // set the timer to this deal
            setDealTimer(deal)
        }
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
                    //println("This is a previously pulled deal, checking dates")
                    // we need to check the date
                    let expiresTime = dealPreviouslyDisplayed?.expirationDate
                    // see how much time has lapsed
                    var compareDates: NSComparisonResult = NSDate().compare(expiresTime!)
                    if compareDates == NSComparisonResult.OrderedAscending {
                        // the deal has not expired yet
                      //  println("This deal is still good")
                    } else {
                        //the deal has expired
                       // println("This deal has expired")
                        // TODO: If deal is over 3 hours old, delete it immedietly and reload
                        venueDeal.validValue = 2
                        // update the db
                        realm.write {
                            self.realm.create(VenueDeal.self, value: venueDeal, update: true)
                        }
                    }
                } else {
                   // println("This is a new deal, setting expiration date")
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
            selectedDeal = dealList[0]
            setDealTimer(selectedDeal!)
            if currentSavedDealId != "" {
                saveSwapButton.enabled = (currentSavedDealId == selectedDeal?.id) ? false : true
            }
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
            self.collectionView.reloadData()
        })
        
    }
    
    //  ------------------------ COLLECTIONVIEW METHODS  ----------------------------------
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 1
        // Return the number of sections
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dealList.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dealCell", forIndexPath: indexPath) as! DealCardCell
        let deal: VenueDeal = dealList[indexPath.row]
        cell.setUpVenueDeal(deal)
        pageController.numberOfPages = dealList.count
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // get the height of the view
        var height: CGFloat = collectionCardView.bounds.height * 0.75
        var width = height * 1.9
        
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        var cell : UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        let deal: VenueDeal = dealList[indexPath.row]
        // set the timer to this deal
        setDealTimer(deal)
        selectedDeal = deal
        // set the timer to this deal
        setDealTimer(selectedDeal!)
        if currentSavedDealId != "" {
            saveSwapButton.enabled = (currentSavedDealId == selectedDeal?.id) ? false : true
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let one = Double(scrollView.contentOffset.x)
        let two = Double(self.view.frame.width)
        let result = one / two
        
        if result != 0{
            if (0.0 != fmodf(Float(result), 1.0)){
                pageController.currentPage = Int(Float(result) + 1)
                let indexPath = NSIndexPath(forRow: Int(Float(result) + 1), inSection: 0)
                collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
                selectedDeal = dealList[indexPath.row]
                // set the timer to this deal
                setDealTimer(selectedDeal!)
                if currentSavedDealId != "" {
                    saveSwapButton.enabled = (currentSavedDealId == selectedDeal?.id) ? false : true
                }
            }else{
                pageController.currentPage = Int(result)
                let indexPath = NSIndexPath(forRow: Int(result), inSection: 0)
                collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
                selectedDeal = dealList[indexPath.row]
                // set the timer to this deal
                setDealTimer(selectedDeal!)
                if currentSavedDealId != "" {
                    saveSwapButton.enabled = (currentSavedDealId == selectedDeal?.id) ? false : true
                }
            }
        }
    }
    
    func setDealTimer(deal: VenueDeal) {
        // Set up the timer countdown label
        let now = NSDate()
        let expires = deal.expirationDate
        let calendar = NSCalendar.currentCalendar()
        let datecomponenets = calendar.components(NSCalendarUnit.CalendarUnitSecond, fromDate: now, toDate: expires, options: nil)
        let seconds = datecomponenets.second * 1000
        if seconds > 0 {
            timeLimitLabel.countDirection = 1
            timeLimitLabel.startValue = UInt64(seconds)
            timeLimitLabel.start()
        }
       // println("Seconds: \(seconds) times 1000")
        if seconds <= 0 {
            timeLimitLabel.stop()
            // set this deal to delete and the view to reload
        }
    }
    
    func setSavedDealTimer(deal: SavedDeal) {
        // Set up the timer countdown label
        let now = NSDate()
        let expires = deal.expirationDate
        let calendar = NSCalendar.currentCalendar()
        let datecomponenets = calendar.components(NSCalendarUnit.CalendarUnitSecond, fromDate: now, toDate: expires, options: nil)
        let seconds = datecomponenets.second * 1000
        // println("Seconds: \(seconds) times 1000")
        timeLimitLabel.countDirection = 1
        timeLimitLabel.startValue = UInt64(seconds)
        timeLimitLabel.start()
        if seconds <= 0 {
            timeLimitLabel.stop()
            // set this deal to delete and the view to reload
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
            println("We don't have any deals yet")
            // if dealList.count == 0 {
            //println("Have location, gather local deals")
            loadSaloofData()
            // get  local deals
            /*
            let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var token = prefs.stringForKey("TOKEN")
            let location = self.locationManager.location
            var userLocation = "?lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)"
            if APICalls.getLocalDeals(token!, location: userLocation) {
                println("Retrieved deals from Saloof")
                haveItems = true
                // FINISHED CREATING DATA OBJECTS
                // get a list of all deal objects in Realm
                validDeals = Realm().objects(VenueDeal)
                println("We have \(validDeals.count) returned deals")
                // Sort all deals by value
                let sortedDeals = Realm().objects(VenueDeal).filter("\(Constants.dealValid) = \(1)").sorted("value", ascending:true)
                validDeals = sortedDeals
                //println("Sorted Deals from ParseJSON \(sortedDeals)")
                biddingStart()
                // pullLocalDeals()
            } else {
                 println("Unable to retrieved deals from Saloof")
            }*/
        }
    }
}
