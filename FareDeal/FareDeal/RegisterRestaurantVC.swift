//
//  SignupVC.swift
//  authentication test
//
//  Created by Nazir Shuqair on 7/14/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class RegisterRestaurantVC: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCField: UITextField!
    
    let authenticationCall:AuthenticationCalls = AuthenticationCalls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0{
            
            //sign up here
            
            if authenticationCall.registerRestaurant(usernameField.text, password: passwordField.text, confirm_password: passwordCField.text) {
                
                if authenticationCall.signIn(usernameField.text, password: passwordField.text){
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            
        }else if _sender.tag == 1{
            
            self.navigationController?.popViewControllerAnimated(true)

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
