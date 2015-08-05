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
import CoreLocation


class RegisterRestaurantVC2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

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
    var validatedlat = 0.0
    var validatedlng = 0.0
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
    @IBOutlet weak var weekdayO: UIButton!
    @IBOutlet weak var weekdayC: UIButton!
    @IBOutlet weak var weekendO: UIButton!
    @IBOutlet weak var weekendC: UIButton!
    //Picture
    @IBOutlet weak var imgView: UIImageView!
    var newMedia: Bool?
    
    @IBOutlet weak var requiredLabel: UILabel!
    var validImage = false
    //Register/Edit button
    @IBOutlet var editNRegister: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet weak var contactName: UITextField!
    
    var profileView = false
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let authenticationCall:AuthenticationCalls = AuthenticationCalls()
    let validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Addes guesture to hide keyboard when tapping on the view
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        zipecodeField.delegate = self
        
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
        styleElements(true)
    }
    
    override func viewDidLayoutSubviews() {
        // set the rounded corners after autolayout has finished
        styleElements(false)
    }
    
    func styleElements(didLoad: Bool){
        
        var elementArray = [restNameField, streetField, cityField, zipecodeField, phoneNumField, websiteField, contactName]

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
            catButton.roundCorners(.AllCorners, radius: 14)
            weekdayC.roundCorners(.AllCorners, radius: 14)
            weekdayO.roundCorners(.AllCorners, radius: 14)
            weekendC.roundCorners(.AllCorners, radius: 14)
            weekendO.roundCorners(.AllCorners, radius: 14)
            priceControls.roundCorners(.AllCorners, radius: 9)
            editNRegister.roundCorners(.AllCorners, radius: 14)
            
        }
    }
    
    
    func signOut(){
        
        prefs.setObject(nil, forKey: "TOKEN")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Validates address and retrives coordinates
        findCoorinates(("\(streetField.text), \(cityField.text), \(zipecodeField.text)"))
    }
    
    @IBAction func onClick(_sender:UIButton){
        
        if _sender.tag == 0{
            
            self.startImageAction()
            
        }else if _sender.tag == 1{
            
            //sign up here
            self.signUP()
            
        }else if _sender.tag == 2{
            
            // save updated changes here
            var refreshAlert = UIAlertController(title: "Good to go", message: "Changes have been saved", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction!) in
                self.navigationController?.popViewControllerAnimated(true)
            }))
            self.presentViewController(refreshAlert, animated: true, completion: nil)
            
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
            
            ActionSheetStringPicker.showPickerWithTitle("Time", rows: ["12am", "1am", "2am", "3am", "4am", "5am", "6am", "7am", "8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm", "11pm"] as [AnyObject], initialSelection: 1, doneBlock: {
                picker, value, index in
                
                if sender.tag == 5 {
                    self.weekdayO.setTitle("\(index)", forState: UIControlState.Normal)
                }else if sender.tag == 6{
                    self.weekdayC.setTitle("\(index)", forState: UIControlState.Normal)
                }else if sender.tag == 7{
                    self.weekendO.setTitle("\(index)", forState: UIControlState.Normal)
                }else if sender.tag == 8{
                    self.weekendC.setTitle("\(index)", forState: UIControlState.Normal)
                }
                
                println("value = \(value)")
                println("index = \(index)")
                println("picker = \(picker)")
                return
                }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
            
          }
        
        
    }

    @IBAction func priceControl(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            selectedPrice = 0
        case 1:
            selectedPrice = 1
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
            requiredLabel.hidden = true
            
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
        var restaurantName = restNameField.text
        var street = streetField.text
        var city = cityField.text
        var zipcode = zipecodeField.text
        var phoneNum = phoneNumField.text
        var website = websiteField.text
        var selectedCategory = catButton.titleLabel?.text
        var price = priceControls.selectedSegmentIndex.value
        var contact = contactName.text
        var wkO = weekdayO.titleLabel?.text
        var wkC = weekdayC.titleLabel?.text
        var wknO = weekendO.titleLabel?.text
        var wknC = weekendC.titleLabel?.text
        var weekdayString = validation.formatHours(wkO!, weekC: wkC!, weekendO: wknO!, weekendC: wknC!).weekdayHours
        var weekendString = validation.formatHours(wkO!, weekC: wkC!, weekendO: wknO!, weekendC: wknC!).weekendHours
        
        println("Lat: \(validatedlat), Lng: \(validatedlng)")
        
        if validation.validateInput(restaurantName, check: 1, title: "Too Short", message: "Please enter a valid Restaurant name")
        && validation.validateAddress(street, city: city, zipcode: zipcode, lat: self.validatedlat, lng: self.validatedlng).valid
            && validation.validateInput(phoneNumField.text, check: 9, title: "Too Short", message: "Please enter a valid Phone number")
            && validation.category(selectedCategory!)
            && validation.validateInput(contact, check: 1, title: "Too Short", message: "Please enter a valid name") {

                var registrationPost = "{\"FirstName\":\"\(contact)\",\"LastName\":\"void\",\"StreetName\":\"\(street)\",\"City\":\"\(city)\",\"State\":\"DC\",\"ZipCode\":\"\(zipcode)\",\"PhoneNumber\":\"\(phoneNum)\",\"PriceTier\":\(price),\"WeekdaysHours\":\"\(weekdayString)\",\"WeekEndHours\":\"\(weekendString)\",\"RestaurantName\":\"\(restaurantName)\",\"Lat\":\"\(validatedlat)\",\"Lang\":\"\(validatedlng)\",\"CategoryName\":\"\(selectedCategory)\"}"

                
           // var registrationPost = "\"RestaurantName\":\"\(restNameField.text)\", \"PhoneNumber\":\"\(phoneNum)\", \"CategoryName\":\"\(selectedCategory)\", \"StreetName\":\"\(street)\", \"City\":\"\(city)\",\"State\":\"DC\", \"ZipCode\":\"\(zipcode)\", \"Lat\":\"\(validatedlat)\", \"Lang\":\"\(validatedlng)\",\"WebSite\":\"\(websiteField.text)\",\"PriceTier\":\"\(priceControls.selected)\",\"WeekdaysHours\":\"\(weekdayString)\",\"WeekEndHours\":\"\(weekendString)\",\"FirstName\":\"\(contact)\",\"LastName\":\"void\""
                
                
                authenticationCall.registerRestaurant(registrationPost, token: prefs.stringForKey("TOKEN")!)
            
//            // Testing for now...
//            if authenticationCall.registerRestaurant(callPart1) {
//                
//                var refreshAlert = UIAlertController(title: "Thank you!", message: "Your information has been sent and is pending verification.  We will be in touch soon.  In the mean time, you can start setting-up your deals", preferredStyle: UIAlertControllerStyle.Alert)
//                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction!) in
//                    
//                    //tesitng for now
//                    var stringPost="grant_type=password&username=\(self.username)&password=\(self.pass)"
//
//                    if self.authenticationCall.signIn(stringPost){
//                        self.backTwo()
//                    }
//                }))
//                self.presentViewController(refreshAlert, animated: true, completion: nil)
//            }
            //authenticationCall.registerRestaurant(callPart2)
        }else {
            errorLabel.hidden = false
        }
        
    }
    
    func backTwo() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
    }
    
    
    func saveData(){
        
    }
    
    func findCoorinates(formattedAddress: String) {
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(formattedAddress, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                var location:CLLocation = placemark.location
                var coordinates:CLLocationCoordinate2D = location.coordinate
                self.validatedlat = coordinates.latitude
                self.validatedlng = coordinates.longitude
            }
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the navigation bar to display the full location image
        self.navigationController?.navigationBarHidden = false
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = UIImage()
        navBar.tintColor = .whiteColor()
        navBar.backgroundColor = UIColor.clearColor()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        // restore the navigation bar to origional
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        if navBar != nil {
            navBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
            navBar.shadowImage = nil
            // navBar the background color to whatever we choose
            //bar.backgroundColor = UIColor.clearColor()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
}
