//
//  HomeSwipeViewController.swift
//  FareDeal
//
//  Created by Angela Smith on 7/20/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import Koloda

class HomeSwipeViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate, UISearchBarDelegate {
    
    
    
    @IBOutlet var dealButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet weak var searchDisplayOverview: UIView!
    @IBOutlet weak var swipeableView: KolodaView!
    
    var restaurants: [AnyObject] = []
    var favoriteRestaurants: [AnyObject] = []
    var searchActive : Bool = false
    var searchString = ""
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

    
    
    /* -----------------------  VIEW CONTROLLER METHODS --------------------------- */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Retrieve the default data from the restaurants plist
        let path = NSBundle.mainBundle().pathForResource("Restaurants", ofType:"plist")
        restaurants = NSArray(contentsOfFile: path!) as! [Dictionary<String,AnyObject>]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the Kolodo view delegate and data source
        swipeableView.dataSource = self
        swipeableView.delegate = self
        //swipeableView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
    }

    override func viewDidAppear(animated: Bool) {
        
        // Add the second button to the nav bar
        let logOutButton = UIBarButtonItem(image: UIImage(named: "logOut"), style: .Plain, target: self, action: "logOut")
        self.navigationItem.setLeftBarButtonItems([logOutButton, self.dealButton], animated: true)
        
        swipeableView.reloadData()

    }
    
    
    func logOut () {
    
    
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
        return UInt(restaurants.count)
    }
    
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
        
        //Check this for a better fix of the sizing issue...
        //println("bounds for first 3: \(self.swipeableView.bounds)")
        
        var cardView = CardContentView(frame: self.swipeableView.bounds)
        
        var contentView = NSBundle.mainBundle().loadNibNamed("CardContentView", owner: self, options: nil).first! as! UIView
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //contentView.backgroundColor = cardView.backgroundColor
        
        let restaurant: AnyObject = restaurants[Int(index)]
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
        let restaurant: AnyObject = restaurants[Int(index)]
        // check the direction
        if direction == SwipeResultDirection.Left {
            
        }
        if direction == SwipeResultDirection.Right {
            //println("User: Home: User swiped right, save to favorites")
            // get the object at that index
            favoriteRestaurants.append(restaurant)
        }
        
        //Load more cards
        if index >= 1 {
            
            swipeableView.reloadData()
        }
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //Example: reloading
        swipeableView.resetCurrentCardNumber()
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        // get the restaurant at the index and pass to the detail view
        let restaurant: AnyObject = restaurants[Int(index)]
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("restaurantDetailVC") as! RestaurantDetailController
        self.navigationController?.pushViewController(detailVC, animated: true)
        detailVC.thisRestaurant = restaurant
    }

    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    
    /* -------------------------  SEGUE  -------------------------- */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "userFavoritesSegue" {
            // pass the temporary list of favorites to the favorites view
            let favoritesTVC = segue.destinationViewController as! FavoritesTVController
            //println("User: Home: There are \(favoriteRestaurants.count) favorites")
            favoritesTVC.restaurants = self.favoriteRestaurants
        }
    }
    
}
