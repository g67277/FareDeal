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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0 {
            println("Reset password")
        } else if _sender.tag == 1 {
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
