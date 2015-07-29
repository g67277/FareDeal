//
//  SignupVC.swift
//  authentication test
//
//  Created by Nazir Shuqair on 7/14/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import MobileCoreServices
import ActionSheetPicker_3_0


class RegisterRestaurantVC2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Restaurant Name Field
    @IBOutlet weak var restNameField: UITextField!
    var nameValid = false
    
    //Category
    @IBOutlet weak var catButton: UIButton!
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
    var selectedPrice = 0
    var validPrice = false
    
    //Hours
    @IBOutlet weak var weedayO: UIButton!
    @IBOutlet weak var weekdayC: UIButton!
    @IBOutlet weak var weekendO: UIButton!
    @IBOutlet weak var weekendC: UIButton!
    
    //Picture
    @IBOutlet weak var imgView: UIImageView!
    var newMedia: Bool?
    var validImage = false
    
    //Register/Edit button
    @IBOutlet var editNRegister: UIButton!
    
    var callPart1 = ""
    var callPart2 = ""
    var profileView = false
    
    //Testing
    var username = ""
    var pass = ""
    //Testing
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()


    

    
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
            
            var signOutBtn = UIBarButtonItem(title: "Log off", style: UIBarButtonItemStyle.Done, target: self, action: "signOut")
            navigationItem.rightBarButtonItem = signOutBtn
            
            
        }else{
            editNRegister.setTitle("Register", forState: UIControlState.Normal)
            editNRegister.tag = 1
        }
        
        categoryArray = categories.loadCategories()
        
    }
    
    func signOut(){
        
        prefs.setObject(nil, forKey: "TOKEN")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0{
            
            self.startImageAction()
            
        }else if _sender.tag == 1{
            
            //sign up here
            self.signUP()
            
        }else if _sender.tag == 2{
            
            // save updated changes here
            
        }
        
    }
    @IBAction func pickerSelected(sender: AnyObject) {
        
        if sender.tag == 4 {
            ActionSheetStringPicker.showPickerWithTitle("Category", rows: categoryArray as [AnyObject], initialSelection: 1, doneBlock: {
                picker, value, index in
                
                self.catButton.setTitle("\(index)", forState: UIControlState.Normal)
                
                println("value = \(value)")
                println("index = \(index)")
                println("picker = \(picker)")
                return
                }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
            
        }else if sender.tag > 4 && sender.tag < 9{
            
            ActionSheetStringPicker.showPickerWithTitle("Nav Bar From Picker", rows: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"] as [AnyObject], initialSelection: 1, doneBlock: {
                picker, value, index in
                
                if sender.tag == 5 {
                    self.weedayO.setTitle("\(index) am", forState: UIControlState.Normal)
                }else if sender.tag == 6{
                    self.weekdayC.setTitle("\(index) pm", forState: UIControlState.Normal)
                }else if sender.tag == 7{
                    self.weekendO.setTitle("\(index) am", forState: UIControlState.Normal)
                }else if sender.tag == 8{
                    self.weekendC.setTitle("\(index) pm", forState: UIControlState.Normal)
                }
                
                println("value = \(value)")
                println("index = \(index)")
                println("picker = \(picker)")
                return
                }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
            
            
            
//            var datePicker = ActionSheetDatePicker(title: "Time:", datePickerMode: UIDatePickerMode.Time, selectedDate: NSDate(), doneBlock: {
//                picker, value, index in
//                
//                var test:String = String(stringInterpolationSegment: value)
//                
//                let dateFormatter = NSDateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSxxx"
//                let date = dateFormatter.dateFromString(test)
//                
//                
//                if sender.tag == 5 {
//                    self.weedayO.setTitle("\(value)", forState: UIControlState.Normal)
//                }else if sender.tag == 6{
//                    self.weekdayC.setTitle("\(value)", forState: UIControlState.Normal)
//                }else if sender.tag == 7{
//                    self.weekendO.setTitle("\(value)", forState: UIControlState.Normal)
//                }else if sender.tag == 8{
//                    self.weekendC.setTitle("\(value)", forState: UIControlState.Normal)
//                }
//                
//                println("value = \(value)")
//                println("index = \(index)")
//                println("picker = \(picker.description)")
//                return
//                }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender as! UIView)
//            datePicker.minuteInterval = 20
//            datePicker.showActionSheetPicker()
        }
        
        
    }
    
    
    
    @IBAction func priceControl(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            selectedPrice = 0
        case 1:
            selectedPrice = 1
            println(selectedPrice)
        case 2:
            selectedPrice = 2
        case 3:
            selectedPrice = 3
        default:
            break; 
        }
    }
    
    
    // Camera methods
    
    func startImageAction(){
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
    
    // Registration Call Methods
    
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
        
        if !validImage{
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please add an image to the form"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
 
        
        if nameValid && validAddress && validPhone && validWeb && validPhone && validImage {
            
            callPart2 = "\(callPart1), \"RestName\":\"\(restNameField.text)\", \(formattedAddress), \"PhoneNumber\":\"\(phoneNumField.text)\",\"WebSite\":\"\(websiteField.text)\",\"PriceTier\":\"\(priceControls.selected)\",\"Hours\":\"\(priceControls.selected)\""
            
            // Testing for now...
            if authenticationCall.registerRestaurant2(callPart1) {
                
                var refreshAlert = UIAlertController(title: "Thank you!", message: "Your information has been sent and is pending verification.  We will be in touch soon.  In the mean time, you can start setting-up your deals", preferredStyle: UIAlertControllerStyle.Alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction!) in
                    
                    if self.authenticationCall.signIn(self.username, password: self.pass){
                        self.backTwo()
                    }
                    
                }))
                self.presentViewController(refreshAlert, animated: true, completion: nil)
                
            }
            
            //authenticationCall.registerRestaurant(callPart2)
            
        }
        
        
    }
    
    func backTwo() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
    }
    
    func saveData(){
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
}
