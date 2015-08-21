//
//  HomeViewController.swift
//  AsyncImageTest
//
//  Created by Angela Smith on 8/20/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit
import RealmSwift
import Koloda
import CoreLocation
import SwiftyJSON
import pop
import Concorde

class KolodaPhoto {
    var photoUrlString = ""
    var title = ""
    
    init () {
    }
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        title = (dictionary["title"] as? String)!
        photoUrlString = (dictionary["url"] as? String)!
    }
}


class HomeViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {

    typealias JSONParameters = [String: AnyObject]
    
    private let placeholderImage = "Placeholder"
    
    // Realm Data properties
    let realm = Realm()
    var venues = Realm().objects(Venue)
    var haveItems: Bool = false
    let venueList = List<Venue>()
    
    // Location Properties
    var location: CLLocation!
    var venueLocations : [AnyObject] = []
    var venueItems : [[String: AnyObject]]?
    var manager: OneShotLocationManager?
    var imageCache = [String:UIImage] ()
    
    let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kolodaView.dataSource = self
        kolodaView.delegate = self
        getLocationPermissionAndData()
        // Do any additional setup after loading the view.
    }
    
    func getLocationPermissionAndData() {
        venueList.removeAll()
        // delete any current venues
        var rejectedVenues = Realm().objects(Venue)
        realm.write {
            self.realm.delete(rejectedVenues)
        }
        
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            
            // fetch location or an error
            if let loc = location {
                self.location = loc
                self.fetchFoursquareVenues()
                self.kolodaView.reloadData()
                
            } else if let err = error {
                println("Unable to get user location: \(err.localizedDescription) error code: \(err.code)")
                //self.containerView.removeFromSuperview()
                //self.activityIndicator.stopAnimation()
            }
            // destroy the object immediately to save memory
            self.manager = nil
        }
    }

    
    //MARK: KolodaViewDataSource
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
         return UInt(venueList.count)
    }
    
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
        
        
        var cardView = NSBundle.mainBundle().loadNibNamed("KolodaPhotoView",
        owner: self, options: nil)[0] as? KolodaPhotoView
        let restaurant: Venue = venueList[Int(index)]
        //let progressiveImageView = CCBufferedImageView(frame: photoImageView!.photoView!.bounds)
        AsyncImageLoader.sharedLoader().cancelLoadingImagesForTarget(cardView?.photoImageView)
        if let url = NSURL(string: restaurant.imageUrl) {
            cardView?.photoImageView.image =  UIImage(named: placeholderImage)
            cardView?.photoImageView.imageURL = url
            
             //photoImageView?.photoImageView.load(url)
        }
        
        
        //photoView?.photoImageView?.imageFromUrl(restaurant.imageUrl)
        cardView?.photoTitleLabel?.text = restaurant.name
        cardView?.setBorder()
        return cardView!
        
   
    }
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("CardOverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
    
    //MARK: KolodaViewDelegate
    
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //Example: reloading
       // fetchPhotos()
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://yalantis.com/")!)
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = 9
        animation.springSpeed = 16
        return animation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchFoursquareVenues() {

        let userLocation  = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        let foursquareURl = NSURL(string: "https://api.foursquare.com/v2/venues/explore?&client_id=KNSDVZA1UWUPSYC1QDCHHTLD3UG5HDMBR5JA31L3PHGFYSA0&client_secret=U40WCCSESYMKAI4UYAWGK2FMVE3CBMS0FTON0KODNPEY0LBR&openNow=1&v=20150101&m=foursquare&venuePhotos=1&limit=10&ll=\(userLocation)&query=restaurants")!
        //println(foursquareURl)
        if  let response = NSData(contentsOfURL: foursquareURl) {
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
            }
            //offsetCount = offsetCount + 10
        }
    }
    
    
    func parseJSON(json: JSON, source: String) {
        let venue = Venue()
        venue.identifier = json["id"].stringValue
        venue.phone = json["contact"]["formattedPhone"].stringValue
        venue.name = json["name"].stringValue
        venue.webUrl = json["url"].stringValue
        let imagePrefix = json["photos"]["groups"][0]["items"][0]["prefix"].stringValue
        let imageSuffix = json["photos"]["groups"][0]["items"][0]["suffix"].stringValue
        let imageName = imagePrefix + "400x400" +  imageSuffix
        // Address
        venue.imageUrl = imagePrefix + "400x400" +  imageSuffix
        var locationStreet = json["location"]["address"].stringValue
        var locationCity = json["location"]["city"].stringValue
        var locationState = json["location"]["state"].stringValue
        var locationZip = json["location"]["postalCode"].stringValue
        var address = locationStreet + "\n" + locationCity + ", " + locationState + "  " + locationZip
        venue.address = address
        venue.hours = json["hours"]["status"].stringValue
        var distanceInMeters = json["location"]["distance"].floatValue
        var distanceInMiles = distanceInMeters / 1609.344
        // make sure it is greater than 0
        distanceInMiles = (distanceInMiles > 0) ? distanceInMiles : 0
        var formattedDistance : String = String(format: "%.01f", distanceInMiles)
        venue.distance = formattedDistance
        venue.priceTier = json["price"]["tier"].intValue
        venue.sourceType = source
        venue.swipeValue = 0
        if source == Constants.sourceTypeSaloof {
            // get the default deal
            venue.defaultDealTitle = json["deals"]["deal"][0]["title"].stringValue
            venue.defaultDealDesc = json["deals"]["deal"][0]["description"].stringValue
            venue.defaultDealValue = json["deals"]["deal"][0]["value"].floatValue
            venue.favorites = json[Constants.restStats][Constants.restFavorites].intValue
            venue.likes = json[Constants.restStats][Constants.restLikes].intValue
        }
        let imageUrl = NSURL(string: imageName)
        if let data = NSData(contentsOfURL: imageUrl!){
            
            let venueImage = UIImage(data: data)
            venue.image = venueImage
            venue.hasImage = true
        }
        
        realm.write {
            self.realm.create(Venue.self, value: venue, update: true)
        }
        venueList.append(venue)
    }



}
