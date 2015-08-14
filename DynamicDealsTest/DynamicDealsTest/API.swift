//
//  API.swift
//  DynamicDealsTest
//
//  Created by Nazir Shuqair on 8/10/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import Foundation
import SwiftyJSON


public class API{
    
    class func getMyRestaurant(lat: Double, lng: Double, category: String, price: Int) ->(JSON){
        
        //var callString = "http://ec2-52-2-195-214.compute-1.amazonaws.com/api/Venue/GetVenues?lat=\(lat)&lng=-\(lng)&category=\(category)&priceTier=\(price)"
        
        var callString = "http://ec2-52-2-195-214.compute-1.amazonaws.com/api/Venue/GetVenues?lat=\(lat)&lng=-\(lng)"
        
        var url:NSURL = NSURL(string: callString)!
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.timeoutInterval = 60
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300){
                
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                var error: NSError?
                
                let json = JSON(data: urlData!)
                
                if(json != nil){
                    return json
                    
                } else {
                    var error_msg:NSString
                    if json["error_message"] != nil {
                        error_msg = json["error_message"].string!
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
                    //
                }
                
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
        return nil
        
    }
    
}