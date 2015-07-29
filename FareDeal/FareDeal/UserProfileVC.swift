//
//  UserProfileVC.swift
//  FareDeal
//
//  Created by Angela Smith on 7/29/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0 {
            println("Log User out of view")
            prefs.setObject(nil, forKey: "TOKEN")
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if _sender.tag == 1 {
            println("Move user to consumer side")
            // remove user token
            prefs.setObject(nil, forKey: "TOKEN")
            // set the side to business
            prefs.setInteger(1, forKey: "SIDE")// and return to launch
            self.dismissViewControllerAnimated(true, completion: nil)
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


}
