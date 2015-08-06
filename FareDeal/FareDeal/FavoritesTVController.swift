//
//  FavoritesTVController.swift
//  UserSide
//
//  Created by Angela Smith on 7/20/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesTVController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    // Query using a predicate string
    var favoriteVenues = Realm().objects(FavoriteVenue).filter("\(Constants.realmFilterFavorites) = \(1)")
    
    
    /* -----------------------  VIEW CONTROLLER  METHODS --------------------------- */
    
    
    override func viewWillAppear(animated: Bool) {
        // Remove text and leave back chevron
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.rowHeight = 121
        let image = UIImage(named: "navBarLogo")
        navigationItem.titleView = UIImageView(image: image)
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
        return self.favoriteVenues.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:FavoritesCell = tableView.dequeueReusableCellWithIdentifier("favoritesCell") as! FavoritesCell
        let venue: FavoriteVenue = favoriteVenues[indexPath.row]
        cell.setUpCell(venue.name, phone: venue.phone, image: venue.image!)
        if venue.sourceType == Constants.sourceTypeFoursquare {
            // hide the favorites/likes view
            cell.likesBarView.hidden = true
        } else {
            cell.setUpLikesBar(venue.likes, favorites: venue.favorites, price: venue.priceTier, distance: venue.distance)
        }
        return cell
    }
    
    // Header Cell
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("favHeaderCell") as! FavoriteHeaderCell
        return headerCell
    }
    
    /* -----------------------  SEGUE --------------------------- */
    
    // Pass the selected restaurant object to the detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "restaurantDetailSegue" {
            if let indexPath = self.tableview.indexPathForSelectedRow() {
                var venue: FavoriteVenue = favoriteVenues[indexPath.row]
                let destinationVC = segue.destinationViewController as! RestaurantDetailController
                destinationVC.favVenue = venue
                destinationVC.isFavorite = true
            }
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
