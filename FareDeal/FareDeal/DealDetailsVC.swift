//
//  DealDetailsVC.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/18/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import RealmSwift

class DealDetailsVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTF: UITextView!
    
    @IBOutlet weak var textCounterLabel: UILabel!
    @IBOutlet weak var valueTF: UITextField!
    @IBOutlet weak var hoursRequiredLabel: UILabel!
    @IBOutlet weak var hour1: UIButton!
    @IBOutlet weak var hour2: UIButton!
    @IBOutlet weak var hour3: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    var tier = 0
    var dealTitle = ""
    var desc = ""
    var value = 0.0
    var hours = 0
    var dealID = ""
    var editingMode = false
    
    var realm = Realm()
    
    // View to indicate selected hour button
    let selectedHour:UIView = UIView()
    var timeLimit = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if hours > 0 {
            updateHourButtons(hours)
        }
        if editingMode{
            deleteBtn.hidden = false
        }else{
            deleteBtn.hidden = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false


        // View to indicate selected hour button -- update color to black
        selectedHour.backgroundColor = .blackColor()
        
        tierLabel.text = String(tier)
        titleTF.text = dealTitle
        
        if desc != "" {
            
            descTF.text = desc
            
        }else{
            //Adding placeholder to text view
            descTF.delegate = self
            descTF.text = "Type Here"
            descTF.textColor = UIColor.lightGrayColor()
        }
        
        valueTF.text = String(stringInterpolationSegment: value)
        
        
 
        // Addes guesture to hide keyboard when tapping on the view
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if descTF.textColor == UIColor.lightGrayColor() {
            descTF.text = nil
            descTF.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        var currentCount = 140 - count(descTF.text)
        if currentCount <= 0{
            //var updatedInput = count(descTF.text)
            descTF.text = descTF.text.substringToIndex(descTF.text.endIndex.predecessor())
        }
        self.textCounterLabel.text = "\(currentCount) characters left"
    }

    // Mark# OnClick Method
    
    @IBAction func onClick(_sender : UIButton?){
        
        // if any hour button is clicked, update the position and view the selectedHour view
        
        if _sender?.tag == 0{
            
            updateHourButtons(1)
            
        }else if _sender?.tag == 1{
            
            updateHourButtons(2)
            
        }else if _sender?.tag == 2{
            
            updateHourButtons(3)
            
        }else if _sender?.tag == 3{
            // Save here
            saveDeal()
        }else if _sender?.tag == 4{
            deleteDeal()
        }
    }
    
    // if any hour button is clicked, update the position and view the selectedHour view
    func updateHourButtons(limit: Int){
        
        switch limit{
        case 1:
            selectedHour.frame = CGRectMake(hour1.frame.origin.x, hour1.frame.origin.y + 35, hour1.frame.width, 2)
            break
        case 2:
            selectedHour.frame = CGRectMake(hour2.frame.origin.x, hour2.frame.origin.y + 35, hour2.frame.width, 2)
            break
        case 3:
            selectedHour.frame = CGRectMake(hour3.frame.origin.x, hour3.frame.origin.y + 35, hour3.frame.width, 2)
            break
        default:
            break
        }
        
        hoursRequiredLabel.hidden = true
        container.addSubview(selectedHour)
        timeLimit = limit
        
    }
    
    func saveDeal(){
        
        if count(titleTF.text) > 0 && count(descTF.text) > 0 && count(valueTF.text) > 0 && timeLimit > 0 {
            
            // save here
            var deal = BusinessDeal()
            deal.tier = 1;
            deal.title = titleTF.text
            deal.desc = descTF.text
            deal.value = (valueTF.text as NSString).doubleValue
            deal.timeLimit = timeLimit
            if editingMode {
                deal.id = dealID
            }else{
                deal.id = NSUUID().UUIDString
            }
            
            realm.write{
                self.realm.add(deal, update: self.editingMode)
            }
            
            println("saved")
            
            var refreshAlert = UIAlertController(title: "Saved", message: "Deal has been saved", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction!) in
                self.navigationController?.popViewControllerAnimated(true)
            }))
            self.presentViewController(refreshAlert, animated: true, completion: nil)

            
        }else  if count(titleTF.text) < 1{
            titleTF.placeholder = "Required"
        }else if count(descTF.text) < 1 {
            descTF.text = "Required"
            descTF.textColor = UIColor.lightGrayColor()
        }else if count(valueTF.text) < 1 {
            valueTF.placeholder = "Required"
        }else if timeLimit == 0 {
            hoursRequiredLabel.hidden = false
        }
        
    }
    
    func deleteDeal(){
        
        if dealID != ""{
            
            var refreshAlert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this deal", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction!) in
                var dealToDelete = self.realm.objectForPrimaryKey(BusinessDeal.self, key: self.dealID)
                
                self.realm.write{
                    self.realm.delete(dealToDelete!)
                }

                self.navigationController?.popViewControllerAnimated(true)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: {(action: UIAlertAction!) in
            }))
            self.presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    

    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
