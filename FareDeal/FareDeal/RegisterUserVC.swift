//
//  SignupVC.swift
//  authentication test
//
//  Created by Nazir Shuqair on 7/14/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class RegisterUserVC: UIViewController {
    
    @IBOutlet var registerButtonView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCField: UITextField!
    
    let authenticationCall:AuthenticationCalls = AuthenticationCalls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Addes guesture to hide keyboard when tapping on the view
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        usernameField.attributedPlaceholder = NSAttributedString(string:"Username",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        emailField.attributedPlaceholder = NSAttributedString(string:"Email Address",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        passwordField.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        passwordCField.attributedPlaceholder = NSAttributedString(string:"Confirm Password",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])

    }
    
    override func viewDidLayoutSubviews() {
        
        registerButtonView.roundCorners(.AllCorners, radius: 14)
    }
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0{
            
            //sign up here
            
            if authenticationCall.registerUser(usernameField.text, email: emailField.text, password: passwordField.text, confirm_password: passwordCField.text) {
                
                if authenticationCall.signIn(usernameField.text, password: passwordField.text){
                    navigationController?.popToRootViewControllerAnimated(true)
                }
            }
            
        }else if _sender.tag == 1{
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the navigation bar to display the full location image
        self.navigationController?.navigationBarHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
