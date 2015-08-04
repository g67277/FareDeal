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
    @IBOutlet weak var dealValueLabel: UILabel!
    
    var thisVenue: Venue?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRestaurant()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpRestaurant(){
        
        if let venue: Venue = thisVenue {
            
            // String Labels
            if var locationLabel = locationName {
                locationLabel.text = venue.name
            }
            if var phoneLabel = phoneTextView {
                phoneLabel.text = venue.phone
            }
            if var addressTextView = addressTextview {
                addressTextView.text = venue.address
            }
            if var websiteTextView = websiteUrlTextView {
                websiteTextView.text = venue.webUrl
            }
            
            // Image
            if var imageView = locationImage {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = venue.image
            }
            
            
            // Number Labels
            if var tierLabel = priceTierlabel {
                var priceTierValue = venue.priceTier
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
                var userDistance = venue.distance
                var miles = userDistance/5280
                let distance = Int(floor(miles))
                distanceLabel.text = (distance == 1) ? "\(distance) mile" : "\(distance) miles"
            }
            
            if var statusLabel = hoursStatusLabel {
                let hours = venue.hours
                // set the status for the hours, or "Is Open" if one was not provided (only open locations are displayed)
                statusLabel.text = (hours == "") ? "Is Open": hours
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the navigation bar to display the full location image
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = UIImage()
        navBar.backgroundColor = UIColor.clearColor()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        // restore the navigation bar to origional
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        navBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = nil
    }
    
    /* -------------------------  SEGUE  -------------------------- */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "viewDefaultDealSegue" {

            let detailVC = segue.destinationViewController as! RestaurantDealDetaislVC
           /* detailVC.thisRestaurant = thisRestaurant
            // get the deal for this restaurant
            if let locationDeals: AnyObject = thisRestaurant {
                 var locationDeals = locationDeals["deals"] as! [AnyObject]
                 var deal = locationDeals[0] as! [String: AnyObject]
                detailVC.thisDeal = deal
            }*/
        }
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

