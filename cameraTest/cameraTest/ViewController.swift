//
//  ViewController.swift
//  cameraTest
//
//  Created by Nazir Shuqair on 7/28/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var catTableView: UITableView!
    
    var jpegImg = NSData()
    var pngImg = NSData()
    
    
    @IBOutlet weak var imageView: UIImageView!
    var newMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showActionSheetTapped(sender: AnyObject) {
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Swiftly Now! Choose an option!", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -> Void in
            //Code for launching the camera goes here
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.Camera) {
                    
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType =
                        UIImagePickerControllerSourceType.Camera
                    imagePicker.mediaTypes = [kUTTypeImage as NSString]
                    imagePicker.allowsEditing = false
                    
                    self.presentViewController(imagePicker, animated: true,
                        completion: nil)
                    self.newMedia = true
            }
            
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            //Code for picking from camera roll goes here
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType =
                        UIImagePickerControllerSourceType.PhotoLibrary
                    imagePicker.mediaTypes = [kUTTypeImage as NSString]
                    imagePicker.allowsEditing = false
                    self.presentViewController(imagePicker, animated: true,
                        completion: nil)
                    self.newMedia = false
            }
        }
        
        actionSheetController.addAction(choosePictureAction)
        
        //We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as! UIView;
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func onClick(sender: AnyObject) {
        
        // send img here
        //saveImg()
        //saveImg()
        saveImg2()
    }
    
    func saveImg2(){
        var testImg = UIImage(named: "btn")
        var imageData = UIImageJPEGRepresentation(testImg, 0.9)
        var base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) // encode the image
        
        var url = "http://ec2-52-2-195-214.compute-1.amazonaws.com/api/Image"
        var token = "Bearer ooLCfhseTGOpxvuV5GxnliHb0ixCfC8F_DmZg9wzYOwy1-F5w4TKmOKZXDdgNEi-b03XDAtBDMm7xDG57jUX7xyKnxVfSAZbC-DauAyoFElTRluQPMP2z-yP8ZsNrFK2PqxGOibztbDTWdGNKwRIsbFY_kH93vXYKGOUz3BdSO02P3pqLY6YWg9Y-mGY91MOD10qRN6LVag4Eet2TH3XqXjTm-x6G8bDzx9vxChw-uZvE60PE_NSQlyOpKlvOoQ4Jxz5CrDgWAWGW2WnK3fB_ZoKBwaC2zvhjub0j47kYm4nR02ArBG1hV2NvmqCCPpw4GzI1F1_pa7ZuOUC1b0s7gvNnzebKqsqIuX0WVA2QOuhwNkrSFJjrXXKUR8tOj3uJsOwSwXrzeGBQSrFOlHxAPPPopRWtJIhyf2Ert1Rts8ET_n6tjgBdwh5CXcvS1IK72MMCAHLwaj5Icg4Eml5QySCq9qQ5jKBtii_ec32j0I5kcWLsTGSloNRtk_NgYZEhVpBEfb9Fa8vRW0YJyHtdw"
        
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        
        request.timeoutInterval = 60
        //request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("test", forHTTPHeaderField: "ImageId")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var err: NSError? = nil
        var params = ["image":[ "content_type": "image/jpeg", "filename":"test.jpg", "file_data": base64String]]
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(0), error: &err)!
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            
            // process the response
        })
        
        task.resume() // this is needed to start the task
    }
    
    func saveImg(){
        
                var testImg = UIImage(named: "btn")
                var testData = UIImagePNGRepresentation(testImg)
                var testData2 = UIImageJPEGRepresentation(testImg, 0.9)
        
                var token = "Bearer ooLCfhseTGOpxvuV5GxnliHb0ixCfC8F_DmZg9wzYOwy1-F5w4TKmOKZXDdgNEi-b03XDAtBDMm7xDG57jUX7xyKnxVfSAZbC-DauAyoFElTRluQPMP2z-yP8ZsNrFK2PqxGOibztbDTWdGNKwRIsbFY_kH93vXYKGOUz3BdSO02P3pqLY6YWg9Y-mGY91MOD10qRN6LVag4Eet2TH3XqXjTm-x6G8bDzx9vxChw-uZvE60PE_NSQlyOpKlvOoQ4Jxz5CrDgWAWGW2WnK3fB_ZoKBwaC2zvhjub0j47kYm4nR02ArBG1hV2NvmqCCPpw4GzI1F1_pa7ZuOUC1b0s7gvNnzebKqsqIuX0WVA2QOuhwNkrSFJjrXXKUR8tOj3uJsOwSwXrzeGBQSrFOlHxAPPPopRWtJIhyf2Ert1Rts8ET_n6tjgBdwh5CXcvS1IK72MMCAHLwaj5Icg4Eml5QySCq9qQ5jKBtii_ec32j0I5kcWLsTGSloNRtk_NgYZEhVpBEfb9Fa8vRW0YJyHtdw"
        
                var base64String = testData2.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) // encode the image
                var postLength:NSString = String( testData2.length)
        
        
                var url = "http://ec2-52-2-195-214.compute-1.amazonaws.com/api/Image"
                var request = NSMutableURLRequest(URL: NSURL(string: url)!)
                request.HTTPMethod = "POST"
                request.timeoutInterval = 60
                request.setValue(token, forHTTPHeaderField: "Authorization")
                request.addValue("test", forHTTPHeaderField: "ImageId")
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
        
                var err: NSError? = nil
                var params = ["image":[ "content_type": "image/jpeg", "filename":"test.jpeg", "file_data": base64String]]
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(0), error: &err)!
        
                var session = NSURLSession.sharedSession()
                var task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    var err: NSError?
        
                    // process the response
                })
        
                task.resume() // this is needed to start the task
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as! String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            imageView.image = image
            var test = image
            jpegImg = UIImageJPEGRepresentation(image, 100)
            pngImg = UIImagePNGRepresentation(image)
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as! String) {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}

