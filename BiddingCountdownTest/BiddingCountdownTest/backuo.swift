//
//  backuo.swift
//  BiddingCountdownTest
//
//  Created by Angela Smith on 7/30/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class backuo: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        
        // Add the second button to the nav bar
        let logOutButton = UIBarButtonItem(image: UIImage(named: "logOut"), style: .Plain, target: self, action: "logOut")
        self.navigationItem.setLeftBarButtonItems([logOutButton, self.dealButton], animated: true)
        
        swipeableView.reloadData()
        
    }
    
    
    func logOut () {
        
        
    }


}
