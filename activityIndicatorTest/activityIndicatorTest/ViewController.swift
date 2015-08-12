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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orangeColor()
        
        }
    
    override func viewDidLayoutSubviews() {
        
        let aIView = CustomActivityView(frame: CGRect (x: 0, y: 0, width: 150, height: 150), color: UIColor.whiteColor(), size: CGSize(width: 70, height: 70))
        activityIndicatorView.addSubview(aIView)
        aIView.startAnimation()

    }
}

