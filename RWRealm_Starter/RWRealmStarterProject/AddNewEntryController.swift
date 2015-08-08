//
//  AddNewEntryController.swift
//  RWRealmStarterProject
//
//  Created by Bill Kastanakis on 8/6/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

import UIKit
import Realm

class AddNewEntryController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextView!
  
  var selectedAnnotation: SpecimenAnnotation!

  //MARK: - Validation
  
  func validateFields() -> Bool {
    
    if (nameTextField.text.isEmpty || descriptionTextField.text.isEmpty) {
      let alertController = UIAlertController(title: "Validation Error", message: "All fields must be filled", preferredStyle: .Alert)
      let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: {(alert : UIAlertAction!) in
        alertController.dismissViewControllerAnimated(true, completion: nil)
      })
      alertController.addAction(alertAction)
      presentViewController(alertController, animated: true, completion: nil)
      
      return false
      
    } else {
      return true
    }
  }

  //MARK: - UITextFieldDelegate
  
  func textFieldDidBeginEditing(textField: UITextField) {
    performSegueWithIdentifier("Categories", sender: self)
  }
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  @IBAction func unwindFromCategories(segue: UIStoryboardSegue) {
    let categoriesController = segue.sourceViewController as! CategoriesTableViewController

  }
  
  //MARK: - Actions
  
//  override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
//    
//  }
  
}
