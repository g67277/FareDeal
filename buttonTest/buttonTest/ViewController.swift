//
//  ViewController.swift
//  buttonTest
//
//  Created by Angela Smith on 8/13/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onclick(sender: UIButton) {
        if sender.tag == 0 {
            button1.setTitle("1 updated", forState: UIControlState.Normal)
        } else if sender.tag == 1 {
            button2.setTitle("2 updated", forState: UIControlState.Normal)
        } else if sender.tag == 2 {
            button3.setTitle("3 updated", forState: UIControlState.Normal)
        }
    }
    
    func saveData( btn1: String, btn2: String, btn3: String){
        
        println("Saved button titles: \(btn1), \(btn2), \(btn3)")
        
    }

    @IBAction func saveDataTest(sender: AnyObject) {
        var button1t = button1.titleLabel?.text
        var button2t = button2.titleLabel?.text
        var button3t = button3.titleLabel?.text
        /*
        var button1t = ""
        var button2t = ""
        var button3t = ""
        if let button1Text = button1.titleLabel!.text {
           button1t = button1Text
        }
        if let button2Text = button2.titleLabel!.text {
            button2t = button2Text
        }
        if let button3Text = button3.titleLabel!.text {
            button3t = button3Text
        }*/
       saveData(button1t!, btn2: button2t!, btn3: button3t!)
    }
}

