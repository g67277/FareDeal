//
//  SelectorActionSheetTestVC.swift
//  cameraTest
//
//  Created by Nazir Shuqair on 7/29/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class SelectorActionSheetTestVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var countryLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var delegate = UIApplication.sharedApplication()
        var myWindow: UIWindow? = delegate.keyWindow
        var myWindow2: NSArray = delegate.windows
        
        if let myWindow: UIWindow = UIApplication.sharedApplication().keyWindow
        {
            window = myWindow
        }
        else
        {
            window = myWindow2[0] as? UIWindow
        }
        
        picker.backgroundColor = UIColor.whiteColor()
        
        actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height.0, UIScreen.mainScreen().bounds.size.width, 260.0)
        
        //var filePath =  NSBundle.mainBundle().pathForResource("countries", ofType: "plist")
        countriesArray = ["a", "b"]
        countriesArray.insertObject("", atIndex: 0)
        countriesArray.insertObject("No country", atIndex: 0)
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.setNavigationBarItem()
    }
    
    
    var picker = UIPickerView()
    var pickerData  = NSArray()
    var countriesArray: NSMutableArray =  NSMutableArray()
    var actionView: UIView = UIView()
    
    var window: UIWindow? = nil

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - Picker delegate
    
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return pickerData.objectAtIndex(row) as! NSString as String
    }
    
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    
    @IBAction func openPicker(sender : UIButton)
    {
        let kSCREEN_WIDTH  =    UIScreen.mainScreen().bounds.size.width
        
        picker.frame = CGRectMake(0.0, 44.0,kSCREEN_WIDTH, 216.0)
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true;
        picker.backgroundColor = UIColor.whiteColor()
        
        var pickerDateToolbar = UIToolbar(frame: CGRectMake(0, 0, kSCREEN_WIDTH, 44))
        pickerDateToolbar.barStyle = UIBarStyle.Black
        pickerDateToolbar.barTintColor = UIColor.blackColor()
        pickerDateToolbar.translucent = true
        
        var barItems = NSMutableArray()
        
        var labelCancel = UILabel()
        labelCancel.text = "Cancel"
        var titleCancel = UIBarButtonItem(title: labelCancel.text, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPickerSelectionButtonClicked:"))
        barItems.addObject(titleCancel)
        
        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barItems.addObject(flexSpace)
        
        pickerData = countriesArray
        picker.selectRow(1, inComponent: 0, animated: false)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("countryDoneClicked:"))
        barItems.addObject(doneBtn)
        
        pickerDateToolbar.setItems(barItems as [AnyObject], animated: true)
        
        actionView.addSubview(pickerDateToolbar)
        actionView.addSubview(picker)
        
        if ((window) != nil) {
            window!.addSubview(actionView)
        }
        else
        {
            self.view.addSubview(actionView)
        }
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 260.0, UIScreen.mainScreen().bounds.size.width, 260.0)
            
        })
    }
    
    
    func cancelPickerSelectionButtonClicked(sender: UIBarButtonItem) {
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    func countryDoneClicked(sender: UIBarButtonItem) {
        
        
        var myRow = picker.selectedRowInComponent(0)
        countryLabel?.text = pickerData.objectAtIndex(myRow) as! String
        
        if countryLabel?.text == "" {
            countryLabel?.text = "No country"
        }
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }

}
