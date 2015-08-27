//
//  ViewController.swift
//  urlTest
//
//  Created by Angela Smith on 8/27/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var validLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text != "" {
            validateText(textField.text)
        }
        return false
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    
    // This check the currently entered website
    func validateText(website: String) {
        println("validating: \(website)")
        shouldValidateWebsiteUrl(website, completion: { result in
            if result {
                dispatch_async(dispatch_get_main_queue()){
                    self.validLabel.text = "true"
                }
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    // try with adding a http:// prefix
                    self.validateWithPrefix(website)
                }
            }
        })
    }
    
    func validateWithPrefix(website: String) {
        var prefix = "http://" + website
        println("validating: \(prefix)")
        shouldValidateWebsiteUrl(prefix, completion: { result in
            if result {
                dispatch_async(dispatch_get_main_queue()){
                    self.validLabel.text = "true"
                }
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    self.validLabel.text = "false"
                }
            }
        })
    }
    
    func shouldValidateWebsiteUrl(websiteString: String, completion: Bool -> ()){
        // try running an asynchronous request to the site to see if it is active
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url = NSURL(string: websiteString as String)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue(), completionHandler:
            {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let rsp = response as! NSHTTPURLResponse?
                // return the status code
                completion(rsp?.statusCode == 200)
        })
    }


}

