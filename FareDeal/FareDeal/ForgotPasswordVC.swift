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
    let authenticationCall:AuthenticationCalls = AuthenticationCalls()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Addes guesture to hide keyboard when tapping on the view
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        // set the rounded corners after autolayout has finished
        resetPasswordButtonView.roundCorners(.AllCorners, radius: 14)
    }
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0 {
            
            if validateEmail(emailTextField.text){
                
                if authenticationCall.resetPassword(emailTextField.text){
                    var refreshAlert = UIAlertController(title: "Done", message: "Check your email for a reset link", preferredStyle: UIAlertControllerStyle.Alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction!) in
                        self.navigationController?.popViewControllerAnimated(true)
                    }))
                    self.presentViewController(refreshAlert, animated: true, completion: nil)
                }
            }else{
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Please enter a valid email address"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
            
        } else if _sender.tag == 1 {
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
