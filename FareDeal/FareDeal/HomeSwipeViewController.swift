//
//  HomeSwipeViewController.swift
//  FareDeal
//
//  Created by Angela Smith on 7/20/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import Koloda

class HomeSwipeViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {

    @IBOutlet weak var swipeableView: KolodaView!
    var restaurants = []
    
    /* -----------------------  VIEW CONTROLLER METHODS --------------------------- */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Retrieve the default data from the restaurants plist
        let path = NSBundle.mainBundle().pathForResource("Restaurants", ofType:"plist")
        restaurants = NSArray(contentsOfFile: path!) as! [Dictionary<String,String>]
        //println(restaurants.description)
    }
    
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
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    


}
