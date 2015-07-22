//
//  FavoritesTVController.swift
//  UserSide
//
//  Created by Angela Smith on 7/20/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class FavoritesTVController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var restaurants: [AnyObject] = []
    @IBOutlet weak var tableview: UITableView!
    
    
    
    /* -----------------------  VIEW CONTROLLER  METHODS --------------------------- */
    
    
    override func viewWillAppear(animated: Bool) {
        // Remove text and leave back chevron
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.rowHeight = 121
        
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
        return self.restaurants.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:FavoritesCell = tableView.dequeueReusableCellWithIdentifier("favoritesCell") as! FavoritesCell
        
        let restaurant: AnyObject = restaurants[indexPath.row]
        var imageName = restaurant["imageUrl"] as! String
        cell.setUpCell(restaurant["name"]as! String, phone: restaurant["phone"]as! String, image: UIImage (named: imageName)!)
        return cell
    }
    
    /* -----------------------  SEGUE --------------------------- */
    
    // Pass the selected restaurant object to the detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "restaurantDetailSegue" {
            
            if let indexPath = self.tableview.indexPathForSelectedRow() {
                var restaurant: AnyObject = restaurants[indexPath.row]
                let destinationVC = segue.destinationViewController as! RestaurantDetailController
                destinationVC.thisRestaurant = restaurant
            }
        }
    }
    
    
}
