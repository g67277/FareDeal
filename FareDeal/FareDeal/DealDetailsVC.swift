//
//  DealDetailsVC.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/18/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class DealDetailsVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTF: UITextView!
    @IBOutlet weak var valueTF: UITextField!
    @IBOutlet weak var hoursRequiredLabel: UILabel!
    
    @IBOutlet weak var hour1: UIButton!
    @IBOutlet weak var hour2: UIButton!
    @IBOutlet weak var hour3: UIButton!
    
    var tier = 0
    var dealTitle = ""
    var desc = ""
    var value = 0.0
    var hours = 0
    
    let dataManager = DataManager.sharedInstance()
    
    // View to indicate selected hour button
    let selectedHour:UIView = UIView()
    var timeLimit = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if hours > 0 {
            updateHourButtons(hours)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
        }
    }
    
    // if any hour button is clicked, update the position and view the selectedHour view
    func updateHourButtons(limit: Int){
        
        switch limit{
        case 1:
            selectedHour.frame = CGRectMake(hour1.frame.origin.x, hour1.frame.origin.y + 150, hour1.frame.width, 2)
            break
        case 2:
            selectedHour.frame = CGRectMake(hour2.frame.origin.x, hour2.frame.origin.y + 150, hour2.frame.width, 2)
            break
        case 3:
            selectedHour.frame = CGRectMake(hour3.frame.origin.x, hour3.frame.origin.y + 150, hour3.frame.width, 2)
            break
        default:
            break
        }
        
        hoursRequiredLabel.hidden = true
        self.view.addSubview(selectedHour)
        timeLimit = limit
        
    }
    
    func saveDeal(){
        
        if count(titleTF.text) < 1{
            titleTF.placeholder = "Required"
        }
        if count(descTF.text) < 1 {
            descTF.text = "Required"
            descTF.textColor = UIColor.lightGrayColor()
        }
        if count(valueTF.text) < 1 {
            valueTF.placeholder = "Required"
        }
        
        if timeLimit == 0 {
            hoursRequiredLabel.hidden = false
        }
        
        if count(titleTF.text) > 0 && count(descTF.text) > 0 && count(valueTF.text) > 0 && timeLimit > 0 {
            
            // save here
            var deal:Deal = Deal()
            deal.tier = 1;
            deal.title = titleTF.text
            deal.desc = descTF.text
            deal.value = (valueTF.text as NSString).doubleValue
            deal.timeLimit = timeLimit
            
            self.dataManager.saveDeals(deal){ result in
                
                if result{
                    
                    var refreshAlert = UIAlertController(title: "Saved", message: "Deal has been saved", preferredStyle: UIAlertControllerStyle.Alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction!) in
                        self.navigationController?.popViewControllerAnimated(true)
                    }))
                    self.presentViewController(refreshAlert, animated: true, completion: nil)
                    
                    debugPrintln("saved!")
                }
            }
            
        }
        
    }
    

    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
