//
//  ViewController.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/15/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class BusinessHome: UIViewController {
    
    @IBOutlet weak var creditBalanceLabel: UILabel!
    @IBOutlet weak var dealsSelectedLabel: UILabel!
    @IBOutlet weak var dealsSwapedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let titleFont:UIFont = UIFont(name: "Middlecase Regular-Inline.otf", size: 20)!
//        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: titleFont]

        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults() // user default object
        let creditsAvailable:Int = prefs.integerForKey("credits") as Int
        
        if creditsAvailable > 0 {
            creditBalanceLabel.text = "\(creditsAvailable)C"
        }else{
            creditBalanceLabel.text = "No Credits"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

