//
//  RegisterRestaurantVC3.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 8/6/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import MobileCoreServices
import ActionSheetPicker_3_0
import RealmSwift
import AssetsLibrary

class RegisterRestaurantVC3: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    //Picture
    @IBOutlet weak var imgView: UIImageView!
    var imgUri:NSURL = NSURL()
    var newMedia: Bool?
    var validImage = false
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let authentication = AuthenticationCalls()
    let validation = Validation()
    
    var callPart1 = ""
    var continueSession = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidLayoutSubviews() {
        imgView.roundCorners(.AllCorners, radius: 14)
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0{
            
            self.startImageAction()
        }else if _sender.tag == 1{
            self.signUp()
        }
    }
    
    func signUp(){
        
        if validation.validateInput(contactName.text, check: 2, title: "Too Short", message: "Please enter a valid name")
            && validation.validateInput(descTextView.text, check: 5, title: "Too Short", message: "Please add some more details to the description")
            && validImage{
            
                var callPart2 = "\"ContactName\":\"\(contactName.text)\",\"Desc\":\"\(descTextView.text)\"}"
                var completeCall = "\(callPart1), \(callPart2)"
                //var token = prefs.stringForKey("TOKEN")
                //testing...
                self.saveData()
                prefs.setObject("restID", forKey: "restID")
                self.backThree()
//                if authentication.registerRestaurant(completeCall, token: token!){
//                    
//                    prefs.setObject("restID", forKey: "restID")
//                    var refreshAlert = UIAlertController(title: "Thank you!", message: "Your data has been sent for validation, we'll be in touch soon.  In the mean time, you can start setting up some amazing deals", preferredStyle: UIAlertControllerStyle.Alert)
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction!) in
//                        self.backThree()
//                    }))
//                    self.presentViewController(refreshAlert, animated: true, completion: nil)
//                }
                
        }else if !validImage{
            validation.displayAlert("No Picture", message: "Please add a picture")
        }
        
    }
    
    func saveData(){
        
        var realm = Realm()
        var data = Realm().objectForPrimaryKey(ProfileModel.self, key: "will change")

        realm.write({
            data?.contactName = self.contactName.text
            data?.desc = self.descTextView.text
            data?.imgUri = "\(self.imgUri)"
        })
        
    }
    
    func backThree() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
        if continueSession{
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        }else{
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
        }
        
    }
    
    // Camera methods
    
    func startImageAction(){
        // Take picture here
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Upload a picture", message: "It can be of your restaurant or a of a dish off your menu", preferredStyle: .ActionSheet)
        
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
        //actionSheetController.popoverPresentationController?.sourceView = sender as! UIView;
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as! String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            imgView.image = image
            validImage = true
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as! String) {
                // Code to support video here
            }
            
        }
        
        let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        if let fileAbsoluteUrl = documentsUrl.URLByAppendingPathComponent( "profile.png").absoluteURL {
            println(fileAbsoluteUrl)
        }
        var imageData = UIImageJPEGRepresentation(imgView.image, 0.6)
        var compressedJPGImage = UIImage(data: imageData)
        ALAssetsLibrary().writeImageToSavedPhotosAlbum(compressedJPGImage!.CGImage, orientation: ALAssetOrientation(rawValue: compressedJPGImage!.imageOrientation.rawValue)!,
            completionBlock:{ (path:NSURL!, error:NSError!) -> Void in
                self.imgUri = path
                println("\(path)")  //Here you will get your path
        })
        
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
