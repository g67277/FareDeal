//
//  SignupVC.swift
//  authentication test
//
//  Created by Nazir Shuqair on 7/14/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class RegisterRestaurantVC: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCField: UITextField!
    var passwordValid = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Addes guesture to hide keyboard when tapping on the view
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
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
        
        if count(firstName.text) < 2 {
            firstName.text = ""
            firstName.placeholder = "Please enter a valid name"
        }
        if count(lastName.text) < 2 {
            lastName.text = ""
            lastName.placeholder = "Please enter a valid name"
        }
        if !validateEmail(emailAddressField.text) {
            emailAddressField.text = ""
            emailAddressField.placeholder = "Please enter a valid email address"
        }
        if count(passwordField.text) < 6 {
            passwordField.text = ""
            passwordField.placeholder = "Password needs to be at least 6 characters"
        }else{
            if passwordField.text != passwordCField.text {
                passwordField.text = ""
                passwordCField.text = ""
                passwordField.placeholder = "Password does not match"
                passwordCField.placeholder = "Password does not match"

            }else{
                passwordValid = true
            }
        }
        
        if count(firstName.text) > 2 && count(lastName.text) > 2 && validateEmail(emailAddressField.text) && passwordValid{
            self.performSegueWithIdentifier("toRegister2", sender: nil)
        }
        
        
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toRegister2") {
            var svc = segue.destinationViewController as! RegisterRestaurantVC2;
            
            svc.callPart1 = "\"FirstName\":\"\(firstName.text)\",\"LastName\":\"\(lastName.text)\",\"Email\":\"\(emailAddressField.text)\",\"Password\":\"\(passwordField.text)\",\"ConfirmPassword\":\"\(passwordCField.text)\""
            
        }
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
