//
//  HomeSwipeViewController.swift
//  FareDeal
//
//  Created by Angela Smith on 7/20/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

// NOTE: TO Get the user's locations you will need to add another property to the plist
// Key: NSLocationWhenInUseUsageDescription  VALUE (String): We need your location to find the best deals!

import UIKit
import RealmSwift
import Koloda
import CoreLocation
import SwiftyJSON

class HomeSwipeViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    typealias JSONParameters = [String: AnyObject]
    
    // Realm Data properties
    let realm = Realm()
    var venues = Realm().objects(Venue)
    var haveItems: Bool = false
    
    // Location Properties
    var locationManager : CLLocationManager!
    var venueLocations : [AnyObject] = []
    var venueItems : [[String: AnyObject]]?
    var currentLocation: CLLocation!
    
    //View Properties
    @IBOutlet var dealButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet weak var searchDisplayOverview: UIView!
    @IBOutlet weak var swipeableView: KolodaView!
    
    //var restaurants: [AnyObject] = []
    //var favoriteRestaurants: [AnyObject] = []
    var searchActive : Bool = false
    var searchString = ""
    
    let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    
    
    /* -----------------------  VIEW CONTROLLER METHODS --------------------------- */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the Kolodo view delegate and data source
        swipeableView.dataSource = self
        swipeableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        getLocationPermissionAndData()
    }

    override func viewDidAppear(animated: Bool) {
        // Add the second button to the nav bar
        let logOutButton = UIBarButtonItem(image: UIImage(named: "logOut"), style: .Plain, target: self, action: "logOut")
        self.navigationItem.setLeftBarButtonItems([logOutButton, self.dealButton], animated: true)
    }
    
    
    func logOut () {
        prefs.setObject(nil, forKey: "TOKEN")
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func getLocationPermissionAndData() {
        // Start getting the users location
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        // check device location permission status
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined {
            // Request access
            locationManager.requestWhenInUseAuthorization()
        } else if status == CLAuthorizationStatus.AuthorizedWhenInUse
            || status == CLAuthorizationStatus.AuthorizedAlways {
                // we have permission, get location
                locationManager.startUpdatingLocation()
        } else {
            // We do not have premission, request it
            requestLocationPermission()
        }

    }
    
    /* --------  SEARCH BAR DISPLAY AND DELEGATE METHODS ---------- */
    
    @IBAction func showSearchOverlay(sender: AnyObject) {
        searchDisplayOverview.hidden = !searchDisplayOverview.hidden
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        //println("User: Home: User started editing text")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        //println("User: Home: User finished editing text")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.text = ""
        searchBar.endEditing(true)
        searchDisplayOverview.hidden = true
        // reload cards with active search using search string
        swipeableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.text = ""
        searchBar.endEditing(true)
       // println("User: Home: User clicked search button to search for \(searchString)")
        searchDisplayOverview.hidden = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        searchActive = (searchString.isEmpty) ? false : true
        
    }
    
    
    
    
    /* --------  SWIPEABLE KOLODA VIEW ACTIONS, DATA SOURCE, AND DELEGATE METHODS ---------- */
    
    @IBAction func leftButtonTapped() {
        swipeableView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        swipeableView?.swipe(SwipeResultDirection.Right)
    }
    
    // KolodaView DataSource
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(venues.count)
    }
    
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
        
        //Check this for a better fix of the sizing issue...
        //println("bounds for first 3: \(self.swipeableView.bounds)")
        
        var cardView = CardContentView(frame: self.swipeableView.bounds)
        
        var contentView = NSBundle.mainBundle().loadNibNamed("CardContentView", owner: self, options: nil).first! as! UIView
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let restaurant: Venue = venues[Int(index)]
        //println(restaurant)
        cardView.setUpRestaurant(contentView, dataObject: restaurant)
        cardView.addSubview(contentView)
        
        // Layout constraints to keep card view within the swipeable view bounds as it moves
        let metrics = ["width":cardView.bounds.width, "height": cardView.bounds.height]
        let views = ["contentView": contentView, "cardView": cardView]
        cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(width)]", options: .AlignAllLeft, metrics: metrics, views: views))
        cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView(height)]", options: .AlignAllLeft, metrics: metrics, views: views))
        
        return cardView
    }
    
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("CardOverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
    
    //KolodaView Delegate
    
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
        let swipedVenue: Venue = venues[Int(index)]
        println(swipedVenue)
        // check the direction
        if direction == SwipeResultDirection.Left {
            realm.write {
                swipedVenue.swipeValue = 2
                self.realm.create(Venue.self, value: swipedVenue, update: true)
            }
        }
        if direction == SwipeResultDirection.Right {
            realm.write {
                swipedVenue.swipeValue = 1
                self.realm.create(Venue.self, value: swipedVenue, update: true)
            }
        }
        
        /*
        //Load more cards
        if index == UInt(venues.count) {
            removeRejectedVenues()
           // swipeableView.reloadData()
            println("Need more cards")
        }*/
    }
    
    func removeRejectedVenues () {
         println("removing rejected venues")
        // get all the rejected venues
        var rejectedVenues = Realm().objects(Venue).filter("\(Constants.realmFilterFavorites) = \(2)")
        realm.write {
            self.realm.delete(rejectedVenues)
        }
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        removeRejectedVenues()
        swipeableView.resetCurrentCardNumber()
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        // get the venue at the index and pass to the detail view
        let venue: Venue = venues[Int(index)]
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("restaurantDetailVC") as! RestaurantDetailController
        self.navigationController?.pushViewController(detailVC, animated: true)
        detailVC.thisVenue = venue
    }

    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    
    // ------------------- USER LOCATION PERMISSION REQUEST  ----------------------
    
    func requestLocationPermission() {
        let alertController = UIAlertController(title: "Need Location", message: "To find great restaurants, we need access to your location", preferredStyle: .Alert)
        // Add button action to directly open the settings
        let openSettings = UIAlertAction(title: "Open settings", style: .Default, handler: {
            (action) -> Void in
            let URL = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(URL!)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(openSettings)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(error: NSError) {
        let alertController = UIAlertController(title: "Error", message:error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Denied || status == .Restricted {
            requestLocationPermission()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        showErrorAlert(error)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        // if we dont' have any locations, get some
        if venues.count == 0 {
            println("No restaurants stored")
            //exploreFoursquareVenues()
            loadSaloofData()
        } else {
            println("restaurants stored")
        }
        // once we have locations, stop retrieving their location
        locationManager.stopUpdatingLocation()
    }
    
    func loadSaloofData () {
        let saloofUrl = NSURL(string: "http://www.justwalkingonwater.com/json/venueResponse.json")!
        let response = NSData(contentsOfURL: saloofUrl)!
        println(response)
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
                if let venue = item["venue"] as? JSONParameters {
                    println(venue)
                    let venueJson = JSON(venue)
                    // Parse the JSON file using SwiftlyJSON
                    parseJSON(venueJson, source: Constants.sourceTypeSaloof)
                }
            }
            swipeableView.reloadData()
        }
    }
    
    func exploreFoursquareVenues() {
        // Begin loading data from foursquare
        // get the location
        // check if we need to add a search string
        let searchTerm = (searchActive) ? "&query=\(searchString)" : ""
        let location = self.locationManager.location
        let userLocation  = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        let foursquareURl = NSURL(string: "https://api.foursquare.com/v2/venues/explore?&client_id=KNSDVZA1UWUPSYC1QDCHHTLD3UG5HDMBR5JA31L3PHGFYSA0&client_secret=U40WCCSESYMKAI4UYAWGK2FMVE3CBMS0FTON0KODNPEY0LBR&section=food&openNow=1&v=20150101&m=foursquare&venuePhotos=1&limit=10&ll=\(userLocation)\(searchTerm)")!
        //println(foursquareURl)
        let response = NSData(contentsOfURL: foursquareURl)!
        // De-serialize the response to JSON
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
                if let venue = item["venue"] as? JSONParameters {
                    //println(venue)
                    let venueJson = JSON(venue)
                    // Parse the JSON file using SwiftlyJSON
                    parseJSON(venueJson, source: Constants.sourceTypeFoursquare)
                }
            }
            println("Data gathering completed, retrieved \(venues.count) venues")
            swipeableView.reloadData()
        }
    }
    
    func parseJSON(json: JSON, source: String) {
        let venue = Venue()
        venue.identifier = json["id"].stringValue
        venue.phone = json["contact"]["formattedPhone"].stringValue /* Not working*/
        venue.name = json["name"].stringValue
        venue.webUrl = json["url"].stringValue                       /* Not working*/
        let imagePrefix = json["photos"]["groups"][0]["items"][0]["prefix"].stringValue
        let imageSuffix = json["photos"]["groups"][0]["items"][0]["suffix"].stringValue
        let imageName = imagePrefix + "400x400" +  imageSuffix
        var locationAddress = json["location"]["formattedAddress"][0].stringValue
        var cityAddress = json["location"]["formattedAddress"][1].stringValue
        venue.address = locationAddress + "\n" + cityAddress
        venue.hours = json["hours"]["status"].stringValue
        venue.distance = json["location"]["distance"].floatValue
        venue.priceTier = json["price"]["tier"].intValue
        venue.sourceType = source
        if source == Constants.sourceTypeSaloof {
            // get the default deal
            venue.defaultDealTitle = json["deals"]["deal"][0]["title"].stringValue
            venue.defaultDealDesc = json["deals"]["deal"][0]["description"].stringValue
            venue.defaultDealValue = json["deals"]["deal"][0]["value"].floatValue
        }
        let imageUrl = NSURL(string: imageName)
        if let data = NSData(contentsOfURL: imageUrl!){
            
            let venueImage = UIImage(data: data)
            venue.image = venueImage
        }
        
        realm.write {
            self.realm.add(venue)
        }
    }
    
    @IBAction func shouldPushToSavedDeal(sender: AnyObject) {
        // Check to make sure we have a saved deal
        var savedDeal = realm.objects(SavedDeal).first
        if (savedDeal != nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let dealDetailVC: RestaurantDealDetaislVC = storyboard.instantiateViewControllerWithIdentifier("dealDetailVC") as! RestaurantDealDetaislVC
            dealDetailVC.setUpForSaved = true
            navigationController?.pushViewController(dealDetailVC, animated: true)
        } else {
            // Alert them there isn't a current valid saved deal
            let alertController = UIAlertController(title: "No Deals", message: "Either your deal expired, or you haven't saved one.", preferredStyle: .Alert)
            // Add button action to swap
            let cancelMove = UIAlertAction(title: "Ok", style: .Default, handler: {
                (action) -> Void in
            })
            alertController.addAction(cancelMove)
            presentViewController(alertController, animated: true, completion: nil)
        }

        
    }
    
    

    
}
