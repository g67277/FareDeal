//
//  LoginVC.swift
//  authentication test
//
//  Created by Nazir Shuqair on 7/14/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    let authenticationCall:AuthenticationCalls = AuthenticationCalls()
    let validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Addes guesture to hide keyboard when tapping on the view
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (prefs.objectForKey("TOKEN") == nil) {
            debugPrint("NO token")
            //self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            self.performSegueWithIdentifier("toMain", sender: self)
            //self.usernameLabel.text = prefs.valueForKey("USERNAME") as? String
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        // set the rounded corners after autolayout has finished
        //logInButtonView.roundCorners(.AllCorners, radius: 14)
    }

    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0{
            
            if validation.validateInput(userNameField.text, check: 3, title: "Too Short", message: "Please enter a valid username")
                && validation.validateInput(passwordField.text, check: 0, title: "Empty Password", message: "Please enter a password"){
                
                    var stringPost="grant_type=password&username=\(userNameField.text)&password=\(passwordField.text)"
                    
                    if authenticationCall.signIn(stringPost){
                        self.userNameField.text = ""
                        self.passwordField.text = ""
                        prefs.setObject(userNameField.text, forKey: "USERNAME")
                        
                        if prefs.boolForKey("ROLE"){
                            self.performSegueWithIdentifier("toMain", sender: self)
                        }else{
                            validation.displayAlert("No Permission", message: "Please create a business account to access the business side")
                        }
                    }
            }
        }
        
    }
    
    @IBAction func returnToLogInScreen (segue:UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toUserSide") {
            prefs.setInteger(2, forKey: "SIDE")
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        // Hide the navigation bar to display the full location image
        navigationController?.navigationBarHidden = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
