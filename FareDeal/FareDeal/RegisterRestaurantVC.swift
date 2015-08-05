//
//  SignupVC.swift
//  authentication test
//
//  Created by Nazir Shuqair on 7/14/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegisterRestaurantVC: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCField: UITextField!
    @IBOutlet var nextBtn: UIButton!
    var passwordValid = false
    
    let authenticationCall = AuthenticationCalls()
    let validation = Validation()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Addes guesture to hide keyboard when tapping on the view
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        styleElements(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        // set the rounded corners after autolayout has finished
        styleElements(false)
    }
    
    func styleElements(didLoad: Bool){
        var elementArray = [userName, emailAddressField, passwordField, passwordCField]

        if didLoad{
            for element in elementArray{
                let paddingView = UIView(frame: CGRectMake(0, 0, 15, element.frame.height))
                element.leftView = paddingView
                element.leftViewMode = UITextFieldViewMode.Always
                
            }
        }else {
            for element in elementArray{
                element.roundCorners(.AllCorners, radius: 6)
            }
            nextBtn.roundCorners(.AllCorners, radius: 14)
            
        }
    }
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0{
            
            self.validateInput()
            
        }else if _sender.tag == 1{
            
            self.navigationController?.popViewControllerAnimated(true)

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func validateInput(){
        
        //testing only
        //username.text = "naz"
        //emailAddressField.text = "naz@naz.com"
        passwordField.text = "Test@123"
        passwordCField.text = "Test@123"
        // Delete above


        
        if validation.validateInput(userName.text, check: 2, title: "Somethings Missing", message: "Please enter a valid username")
            && validation.validateEmail(emailAddressField.text)
            && validation.validatePassword(passwordField.text, cpass: passwordCField.text){
                
                
                var post:NSString = "{\"UserName\":\"\(userName.text)\",\"Email\":\"\(emailAddressField.text)\",\"Password\":\"\(passwordField.text)\",\"ConfirmPassword\":\"\(passwordCField.text)\",\"IsBusiness\":\"true\"}"
                
                if authenticationCall.registerUser(post) {
                    var stringPost="grant_type=password&username=\(userName.text)&password=\(passwordField.text)"
                    
                    if authenticationCall.signIn(stringPost){
                        self.performSegueWithIdentifier("toRegister2", sender: nil)
                    }
                }
        }
        
        
    }

    
    override func viewWillAppear(animated: Bool) {
        // Hide the navigation bar to display the full location image
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = UIImage()
        navBar.tintColor = .whiteColor()
        navBar.backgroundColor = UIColor.clearColor()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        // restore the navigation bar to origional
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        navBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = nil
        // navBar the background color to whatever we choose
        //bar.backgroundColor = UIColor.clearColor()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
