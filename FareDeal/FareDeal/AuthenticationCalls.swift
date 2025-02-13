//
//  AuthenticationCalls.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/22/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

public class AuthenticationCalls {
    
    public func signIn(post: NSString) ->(Bool){
        
        if Reachability.isConnectedToNetwork(){
            
            
            var url:NSURL = NSURL(string: "http://ec2-52-2-195-214.compute-1.amazonaws.com/Token")!
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( post.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.timeoutInterval = 60
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                //var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300){
                    
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                    
                    if(jsonData["access_token"] != nil){
                        
                        debugPrint("Login Success")
                        
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(jsonData["access_token"], forKey: "TOKEN")
                        var role: String = jsonData["role"] as! String
                        if role == "business"{
                            prefs.setObject(true, forKey: "ROLE")
                        }else{
                            prefs.setObject(false, forKey: "ROLE")
                        }
                        prefs.synchronize()
                        
                        return true
                        
                    } else {
                        var error_msg:NSString
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                            debugPrint("error response")
                        } else {
                            error_msg = "Unknown Error"
                            debugPrint("Unknown Error")
                        }
                        
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                    
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = jsonData["error_description"] as? String
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                    debugPrint("another error")
                    
                }
            }else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
            
        }else{
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "No network"
            alertView.message = "Please make sure you are connected then try again"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        
        
        
        return false
    }
    
    func registerRestaurant(call: NSString, token: String) -> (Bool){
        
        if Reachability.isConnectedToNetwork(){
            
            var url:NSURL = NSURL(string: "http://ec2-52-2-195-214.compute-1.amazonaws.com/api/Venue")!
            
            var postData:NSData = call.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( call.length)
                        
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.timeoutInterval = 60
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                println(res.debugDescription)
                
                if (res.statusCode >= 200 && res.statusCode < 300){
                    
                    return true
                    
                }else {
                    
                    var error: NSError?
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                    
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = jsonData["error_description"] as? String
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    debugPrint("another error")
                    return false
                }
            }else{
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                return false
            }
        }else{
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "No network"
            alertView.message = "Please make sure you are connected then try again"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        return false
        
    }
    
    func registerUser(post: NSString) -> (Bool){
        
        if Reachability.isConnectedToNetwork(){
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: "http://ec2-52-2-195-214.compute-1.amazonaws.com/api/Account/Register")!
            
            var postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
            
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    
                    //                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    //
                    //                    NSLog("Response ==> %@", responseData);
                    //
                    //                    var error: NSError?
                    //
                    //                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                    //
                    //
                    //                    let success:String = jsonData.valueForKey("role") as! String
                    //
                    //                    //[jsonData[@"success"] integerValue];
                    //
                    //                    NSLog("Success: %ld", success);
                    
                    if(res.statusCode == 200)
                    {
                        NSLog("Sign Up SUCCESS");
                        return true
                    } else {
                        
                        var error: NSError?
                        
                        let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                        
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else if res.statusCode == 400 {
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                    
                    println(jsonData["error_message"])
                    
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Email address is already taken"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }  else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
            
        }else{
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "No network"
            alertView.message = "Please make sure you are connected then try again"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        
        
        
        
        return false
    }
    
    func resetPassword(email: NSString) -> (Bool){
        
        
        if Reachability.isConnectedToNetwork(){
            var url:NSURL = NSURL(string: "http://ec2-52-2-195-214.compute-1.amazonaws.com/api/Account/ForgotPassword?email=\(email)")!
            
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    
                    if(res.statusCode == 201 || res.statusCode == 200)
                    {
                        NSLog("Sign Up SUCCESS");
                        return true
                    } else {
                        
                        var error: NSError?
                        
                        let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                        
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else if res.statusCode == 400 {
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                    
                    println(jsonData["error_message"])
                    
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Email address is already taken"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }  else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }else{
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "No network"
            alertView.message = "Please make sure you are connected then try again"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        return false
    }
    
}
