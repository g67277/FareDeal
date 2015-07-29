//
//  SignupVC.swift
//  authentication test
//
//  Created by Nazir Shuqair on 7/14/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import MobileCoreServices

class RegisterRestaurantVC2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //Restaurant Name Field
    @IBOutlet weak var restNameField: UITextField!
    var nameValid = false
    
    //Category
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var catTableView: UITableView!
    var categories:FoodCategories = FoodCategories()
    var categoryArray = []
    
    // Address
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var zipecodeField: UITextField!
    var formattedAddress = ""
    var validAddress = false
    
    // Phone Number
    @IBOutlet weak var phoneNumField: UITextField!
    var validPhone = false
    @IBOutlet weak var websiteField: UITextField!
    var validWeb = false
    
    // Price Tier
    @IBOutlet weak var priceControls: UISegmentedControl!
    var validPrice = false
    
    //Hours
    @IBOutlet weak var weedayO: UITextField!
    @IBOutlet weak var weekdayC: UITextField!
    @IBOutlet weak var weekendO: UITextField!
    @IBOutlet weak var weekendC: UITextField!
    var validHours = false
    
    //Picture
    @IBOutlet weak var imgView: UIImageView!
    var newMedia: Bool?
    var validImage = false
    
    //Register/Edit button
    @IBOutlet var editNRegister: UIButton!
    
    var callPart1 = ""
    var callPart2 = ""
    var profileView = false
    

    
    let authenticationCall:AuthenticationCalls = AuthenticationCalls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Addes guesture to hide keyboard when tapping on the view
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        if profileView {
            editNRegister.setTitle("Save", forState: UIControlState.Normal)
            editNRegister.tag = 2
        }else{
            editNRegister.setTitle("Register", forState: UIControlState.Normal)
            editNRegister.tag = 1
        }
        
        categoryArray = categories.loadCategories()
        
    }
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0{
            
            // Take picture here
            
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
            //actionSheetController.popoverPresentationController?.sourceView = sender as! UIView;
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
        }else if _sender.tag == 1{
            
            //sign up here
            self.signUP()
            
        }else if _sender.tag == 2{
            
            // save updated changes here
            
        }else if _sender.tag == 4{
            
            if self.catTableView.hidden {
                self.catTableView.hidden = false
            }else {
                self.catTableView.hidden = true
            }
            
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as! String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            imgView.image = image
            
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
    
    func signUP(){
        
        // Checks restaurant name
        if count(restNameField.text) > 2{
            self.nameValid = true
        }else{
            restNameField.text = ""
            restNameField.placeholder = "Please enter a valid name"
            self.nameValid = false
        }
        
        // If those conditions are true, go ahead and format the address
        if count(streetField.text) > 6 && count(cityField.text) > 3 && count(zipecodeField.text) == 5 {
            //Check this later
            formattedAddress = "\"FormattedAddress\":\"\(streetField.text) \(cityField.text) \(zipecodeField.text)\""
            validAddress = true
        }else if count(streetField.text) < 6 || count(cityField.text) < 3 || count(zipecodeField.text) != 5{
            streetField.text = ""
            cityField.text = ""
            zipecodeField.text = ""
            streetField.placeholder = "Please enter a valid address"
            cityField.placeholder = "Please enter a valid city"
            zipecodeField.placeholder = "Please enter a valid zipcode"
            validAddress = false
        }
        
        // Checks if there are enough digits in the phone field
        if count(phoneNumField.text) < 10{
            phoneNumField.text = ""
            phoneNumField.placeholder = "Please enter a valid phone number"
            validPhone = false
        }else{
            validPhone = true
        }
        
        //Checks if the website url is valid
        var url:NSURL = NSURL(string: websiteField.text)!
        
        if count(websiteField.text) < 4 {
            websiteField.text = ""
            websiteField.placeholder = "Please enter a valid website"
            validWeb = false
        }
        
        
        // Will have to come back to URL Validation
                
        if let validURL : NSURL = NSURL(string: websiteField.text){
            validWeb = true
        }else{
            websiteField.text = ""
            websiteField.placeholder = "Please enter a valid website"
            validWeb = false
        }
        
        //Check segmented controls
        // Will do later
        
        //Check hours
        // Will do later
        
        if nameValid && validAddress && validPhone && validWeb && validPhone && validHours && validImage {
            
             callPart2 = "\(callPart1), \"RestName\":\"\(restNameField.text)\", \(formattedAddress), \"PhoneNumber\":\"\(phoneNumField.text)\",\"WebSite\":\"\(websiteField.text)\",\"PriceTier\":\"\(priceControls.selected)\",\"Hours\":\"\(priceControls.selected)\""
            
            authenticationCall.registerRestaurant(callPart2)
            
        }
        
        
    }
    
    func saveData(){
        
    }
    
    // Tableview methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = categoryArray[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        catButton.setTitle(categoryArray[indexPath.row] as? String, forState: UIControlState.Normal)
        catTableView.hidden = true
        println("Testing")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
}
