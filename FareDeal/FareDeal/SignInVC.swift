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
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0{
            
            //authentication here
            //loginHere()
            //testing()
            if authenticationCall.signIn(userNameField.text, password: passwordField.text){
                self.userNameField.text = ""
                self.passwordField.text = ""
                self.performSegueWithIdentifier("toMain", sender: self)
            }

            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
