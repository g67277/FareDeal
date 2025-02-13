//
//  SignupVC.swift
//  authentication test
//
//  Created by Nazir Shuqair on 7/14/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class RegisterUserVC: UIViewController {
    
    //@IBOutlet var registerButtonView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCField: UITextField!
    
    let authenticationCall:AuthenticationCalls = AuthenticationCalls()
    let validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Addes guesture to hide keyboard when tapping on the view
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    override func viewDidLayoutSubviews() {
        
        //registerButtonView.roundCorners(.AllCorners, radius: 14)
    }
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0{
            
            //sign up here
            
            var testing = usernameField.text
            
            if validation.validateInput(usernameField.text, check: 2, title: "Somethings Missing", message: "Please enter a valid username")
            && validation.validateEmail(emailField.text)
                && validation.validatePassword(passwordField.text, cpass: passwordCField.text){
                    var post:NSString = "{\"UserName\":\"\(usernameField.text)\",\"Email\":\"\(emailField.text)\",\"Password\":\"\(passwordField.text)\",\"ConfirmPassword\":\"\(passwordCField.text)\",\"IsBusiness\":\"false\"}"
                    if authenticationCall.registerUser(post) {
                        var stringPost="grant_type=password&username=\(usernameField.text)&password=\(passwordField.text)"
                        
                        if authenticationCall.signIn(stringPost){
                            self.navigationController?.popViewControllerAnimated(false)
                        }
                    }

            }
            
        }else if _sender.tag == 1{
            
            self.navigationController?.popViewControllerAnimated(true)
            
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
