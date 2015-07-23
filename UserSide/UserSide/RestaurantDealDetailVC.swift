//
//  RestaurantDealDetailVC.swift
//  UserSide
//
//  Created by Angela Smith on 7/22/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class RestaurantDealDetailVC: UIViewController {

    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var dealTitleLabel: UILabel!
    @IBOutlet weak var dealdescriptionLabel: UILabel!
    @IBOutlet weak var dealValueLabel: UILabel!
    @IBOutlet weak var dealTimeRemainingLabel: UILabel!

    
    var thisRestaurant: AnyObject?
    var thisDeal: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpDeal()

    }
    
    func setUpDeal(){
        
        if let restaurant: AnyObject = thisRestaurant {
            
            // String Labels
            if var locationLabel = locationName {
                locationLabel.text = restaurant["name"] as? String
            }
            
            // Image
            if var imageView = locationImage {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = UIImage (named: (restaurant["imageUrl"] as? String)!)
            }
        }
        
        // Deal info
        if let deal: AnyObject = thisDeal {
            if var dealTitle = dealTitleLabel {
                dealTitle.text = deal["dealName"] as? String
            }
            if var dealDescription = dealdescriptionLabel {
                dealDescription.text = deal["dealDescription"] as? String
            }
            if var dealValue = dealValueLabel {
                dealValue.text = deal["dealValue"] as? String
            }
        
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // navBar the background color to whatever we choose
        //bar.backgroundColor = UIColor.clearColor()
    }
}
