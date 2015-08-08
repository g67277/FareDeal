//
//  ViewController.swift
//  cameraTest
//
//  Created by Nazir Shuqair on 7/28/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var catTableView: UITableView!
    
    
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
        
        catTableView.hidden = false
        
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as! String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            imageView.image = image
            
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
    
    // Tableview methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.loadCategories().count
    } 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = loadCategories()[indexPath.row] as String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        catButton.setTitle(loadCategories()[indexPath.row] as String, forState: UIControlState.Normal)
        catTableView.hidden = true
        println("Testing")
        
    }
    
    func loadCategories() -> (Array<String>){
        
        
        var categoryArray = [
            "Afghan Restaurant",
            "African Restaurant",
            "American Restaurant",
            "Arepa Restaurant",
            "Argentinian Restaurant",
            "Asian Restaurant",
            "Australian Restaurant",
            "Austrian Restaurant",
            "BBQ Joint",
            "Bagel Shop@",
            "Bakery",
            "Belgian Restaurant",
            "Bistro",
            "Brazilian Restaurant",
            "Breakfast Spot",
            "Bubble Tea Shop",
            "Buffet",
            "Burger Joint",
            "Burrito Place",
            "Cafeteria",
            "Café",
            "Cajun / Creole",
            "Cambodian Restaurant",
            "Caribbean Restaurant",
            "Chinese Restaurant",
            "Coffee Shop",
            "Comfort Food Restaurant",
            "Creperie",
            "Cuban Restaurant",
            "Cupcake Shop",
            "Czech Restaurant",
            "Deli / Bodega",
            "Dessert Shop",
            "Diner",
            "Distillery",
            "Donut Shop",
            "Dumpling Restaurant",
            "Eastern European Restaurant",
            "English Restaurant",
            "Ethiopian Restaurant",
            "Falafel Restaurant",
            "Fast Food Restaurant",
            "Filipino Restaurant",
            "Fish & Chips Shop",
            "Fondue Restaurant",
            "Food Truck",
            "Food",
            "French Restaurant",
            "Fried Chicken Joint",
            "Gastropub",
            "German Restaurant",
            "Gluten-free Restaurant",
            "Greek Restaurant",
            "Halal Restaurant",
            "Hawaiian Restaurant",
            "Himalayan Restaurant",
            "Hot Dog Joint",
            "Hotpot Restaurant",
            "Hungarian Restaurant",
            "Ice Cream Shop",
            "Indian Restaurant",
            "Indonesian Restaurant",
            "Irish Pub",
            "Italian Restaurant",
            "Japanese Restaurant",
            "Jewish Restaurant",
            "Juice Bar",
            "Korean Restaurant",
            "Kosher Restaurant",
            "Latin American Restaurant",
            "Mac & Cheese Joint",
            "Malaysian Restaurant",
            "Mediterranean Restaurant",
            "Mexican Restaurant",
            "Middle Eastern Restaurant",
            "Modern European Restaurant",
            "Molecular Gastronomy Restaurant",
            "Mongolian Restaurant",
            "Moroccan Restaurant",
            "New American Restaurant",
            "Pakistani Restaurant",
            "Persian Restaurant",
            "Peruvian Restaurant",
            "Pie Shop",
            "Pizza Place",
            "Polish Restaurant",
            "Portuguese Restaurant",
            "Ramen / Noodle House",
            "Restaurant",
            "Romanian Restaurant",
            "Russian Restaurant",
            "Salad Place",
            "Sandwich Place",
            "Scandinavian Restaurant",
            "Seafood Restaurant",
            "Snack Place",
            "Soup Place",
            "South American Restaurant",
            "Southern / Soul Food Restaurant",
            "Souvlaki Shop",
            "Spanish Restaurant",
            "Steakhouse",
            "Sushi Restaurant",
            "Swiss Restaurant",
            "Taco Place",
            "Tapas Restaurant",
            "Tea Room",
            "Thai Restaurant",
            "Tibetan Restaurant",
            "Turkish Restaurant",
            "Ukrainian Restaurant",
            "Vegetarian / Vegan Restaurant",
            "Vietnamese Restaurant",
            "Winery",
            "Wings Joint",
            "Frozen Yogurt",
            "Nightlife Spot",
            "Bar",
            "Nightclub",
            "Pub",
            "Sports Bar"]
        
        return categoryArray
        
    }



}

