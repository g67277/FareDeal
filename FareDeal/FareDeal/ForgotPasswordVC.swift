//
//  ForgotPasswordVC.swift
//  FareDeal
//
//  Created by Angela Smith on 7/29/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var resetPasswordButtonView: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    var senderTag: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  if senderTag == 1 {
            // set up for business view
            backgroundImageView.image = UIImage(named:"businessBackground")
            resetPasswordButtonView.backgroundColor = UIColor.blackColor()
        }*/
        // Addes guesture to hide keyboard when tapping on the view
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email Address",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    override func viewDidLayoutSubviews() {
        // set the rounded corners after autolayout has finished
        resetPasswordButtonView.roundCorners(.AllCorners, radius: 14)
    }

}
