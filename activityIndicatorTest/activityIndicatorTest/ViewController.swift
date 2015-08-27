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
     let aIView = CustomActivityView(frame: CGRect (x: 0, y: 0, width: 200, height: 200), color: .whiteColor(), size: CGSize(width: 200, height: 200))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        }
    
    override func viewDidLayoutSubviews() {
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.addSubview(aIView)
    }
    @IBAction func onStart(sender: AnyObject) {
        aIView.startAnimation()
    }

    @IBAction func onStop(sender: AnyObject) {
        aIView.stopAnimation()
    }
}

