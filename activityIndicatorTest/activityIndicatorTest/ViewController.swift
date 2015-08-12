//
//  ViewController.swift
//  activityIndicatorTest
//
//  Created by Angela Smith on 8/4/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var activityIndicatorView: UIView!
     let aIView = CustomActivityView(frame: CGRect (x: 0, y: 0, width: 70, height: 70), color: UIColor(red:0.9, green:0.46, blue:0.33, alpha:1), size: CGSize(width: 70, height: 70))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        activityIndicatorView.addSubview(aIView)

        }
    
    override func viewDidLayoutSubviews() {
        
    }
    @IBAction func onStart(sender: AnyObject) {
        aIView.startAnimation()
    }

    @IBAction func onStop(sender: AnyObject) {
        aIView.stopAnimation()
    }
}

