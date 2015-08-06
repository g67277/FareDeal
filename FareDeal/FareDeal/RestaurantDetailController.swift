//
//  RestaurantDetailController.swift
//  User Side
//
//  Created by Angela Smith on 7/21/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit
import RealmSwift

class RestaurantDetailController: UIViewController {

    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var priceTierlabel: UILabel!
    @IBOutlet weak var locationDistanceLabel: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var addressTextview: UITextView!
    
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var websiteUrlTextView: UITextView!
    @IBOutlet weak var hoursStatusLabel: UILabel!
    
    @IBOutlet weak var dealView: UIView!
    @IBOutlet weak var dealTitleLabel: UILabel!
    @IBOutlet weak var dealDescLabel: UILabel!
    @IBOutlet weak var dealValueLabel: UILabel!
    
    @IBOutlet var favoriteLikesView: UIView!
    @IBOutlet var favoritesLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    
    var thisVenue: Venue?
    var favVenue: FavoriteVenue?
    var isFavorite: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "navBarLogo")
        navigationItem.titleView = UIImageView(image: image)

        // Do any additional setup after loading the view.
        if isFavorite {
            if let venue: FavoriteVenue = favVenue {
                if venue.sourceType == "Saloof" {
                    self.setUpDetailView(venue.name, phone: venue.phone, address: venue.address, website: venue.webUrl, image: venue.image!, priceTier: venue.priceTier, distance: venue.distance, hours: venue.hours, sourceType: venue.sourceType, dealName: venue.defaultDealTitle, dealDesc: venue.defaultDealDesc, dealValue: venue.defaultDealValue, likes: venue.likes, favorites: venue.favorites)
                } else {
                    self.setUpDetailView(venue.name, phone: venue.phone, address: venue.address, website: venue.webUrl, image: venue.image!, priceTier: venue.priceTier, distance: venue.distance, hours: venue.hours, sourceType: venue.sourceType, dealName: "", dealDesc: "", dealValue: 0.0, likes: 0, favorites: 0)
                }
            }
        } else {
            if let venue: Venue = thisVenue {
                if venue.sourceType == "Saloof" {
                    self.setUpDetailView(venue.name, phone: venue.phone, address: venue.address, website: venue.webUrl, image: venue.image!, priceTier: venue.priceTier, distance: venue.distance, hours: venue.hours, sourceType: venue.sourceType, dealName: venue.defaultDealTitle, dealDesc: venue.defaultDealDesc, dealValue: venue.defaultDealValue, likes: venue.likes, favorites: venue.favorites)
                } else {
                    self.setUpDetailView(venue.name, phone: venue.phone, address: venue.address, website: venue.webUrl, image: venue.image!, priceTier: venue.priceTier, distance: venue.distance, hours: venue.hours, sourceType: venue.sourceType, dealName: "", dealDesc: "", dealValue: 0.0, likes: 0, favorites: 0)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpDetailView (name: String, phone: String, address: String, website: String, image: UIImage, priceTier: Int, distance: Float, hours: String, sourceType: String, dealName: String, dealDesc: String, dealValue: Float, likes: Int, favorites: Int) {
        // String Labels
        if var locationLabel = locationName {
            locationLabel.text = name
        }
        if var phoneLabel = phoneTextView {
            phoneLabel.text = (phone == "") ? "Unavailable" : phone
        }
        if var addressTextView = addressTextview {
            addressTextView.text = (address == "") ? "Unavailable" : address
        }
        if var websiteTextView = websiteUrlTextView {
            websiteTextView.text = (website == "") ? "Unavailable" : website
        }
        if var statusLabel = hoursStatusLabel {
            let hours = hours
            // set the status for the hours, or "Is Open" if one was not provided (only open locations are displayed)
            statusLabel.text = (hours == "") ? "Is Open": hours
        }
        
        // Image
        if var imageView = locationImage {
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = image
        }
        
        
        // Number Labels
        if var tierLabel = priceTierlabel {
            var priceTierValue = priceTier
            switch priceTierValue {
            case 0:
                tierLabel.text = ""
            case 1:
                tierLabel.text = "$"
            case 2:
                tierLabel.text = "$$"
            case 3:
                tierLabel.text = "$$$"
            default:
                tierLabel.text = ""
            }
        }
        
        if var distanceLabel = locationDistanceLabel {
            // get the number of miles between the current user and the location,
            var userDistance = distance
            var miles = userDistance/5280
            let distance = Int(floor(miles))
            distanceLabel.text = (distance == 1) ? "\(distance) mile" : "\(distance) miles"
        }
        
        // Default Deal
        if sourceType == "Saloof" {
            // Set up the value
            let valueFloat:Float = dealValue, valueFormat = ".2"
            dealValueLabel.text = "Value: $\(valueFloat.format(valueFormat))"
            if var dealTitle = dealTitleLabel {
                dealTitle.text = dealName
            }
            if var dealDes = dealDescLabel {
                dealDes.text = dealDesc
            }
            if var favsLabel = favoritesLabel {
                favsLabel.text = "\(favorites)"
            }
            if var likeLabel = likesLabel {
                likeLabel.text = "\(likes)"
            }
            // set up the deal
        } else {
            // hide the deal and favorites views
            //dealView.hidden = true
           // favoriteLikesView.hidden = true
        }
        
    }
    
    
    /* -------------------------  SEGUE  -------------------------- */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "viewDefaultDealSegue" {
            let detailVC = segue.destinationViewController as! RestaurantDealDetaislVC
            //create a temporary default deal
            var deal = createDealForDetailView()
            detailVC.thisDeal = deal
            detailVC.setUpForDefault = true
            detailVC.setUpForSaved = false
        }
    }
    
    func createDealForDetailView()-> VenueDeal {
        let venueDeal = VenueDeal()
        venueDeal.name = dealTitleLabel.text!
        venueDeal.desc = dealDescLabel.text!
        venueDeal.tier = 0
        venueDeal.timeLimit = 4
        if isFavorite {
            venueDeal.value = favVenue!.defaultDealValue
            venueDeal.venue.name = favVenue!.name
            venueDeal.venue.identifier = favVenue!.identifier
            venueDeal.venue.image = favVenue!.image
            var venueId = "\(venueDeal.venue.identifier).0)"
            venueDeal.id = venueId
        } else  {
            venueDeal.value = thisVenue!.defaultDealValue
            venueDeal.venue.name = thisVenue!.name
            venueDeal.venue.identifier = thisVenue!.identifier
            var venueId = "\(venueDeal.venue.identifier).0)"
            venueDeal.venue.image = thisVenue!.image
            venueDeal.id = venueId
        }
        let realm = Realm()
        realm.write {
            realm.create(VenueDeal.self, value: venueDeal, update: true)
        }

        return venueDeal
    }
    
    @IBAction func shouldPushToSavedDeal(sender: AnyObject) {
        // Check to make sure we have a saved deal
        let realm = Realm()
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

