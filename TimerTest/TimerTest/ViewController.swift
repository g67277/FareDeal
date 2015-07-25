//
//  ViewController.swift
//  TimerTest
//
//  Created by Angela Smith on 7/24/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //@IBOutlet var timer: TTCounterLabel!
     var names: [AnyObject] = ["Joe", "Bob", "Galup", "Gnome", "Tuesday"]
     var numbers: [Int] = [1,3,2,1,3]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // couldn't set the display mode, so source file was reversed to not show milliseconds
        //timer.displayMode
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    @IBAction func startTimer(sender: AnyObject) {
        timer.start()
    }
    
    @IBAction func stopTimer(sender: AnyObject) {
        timer.stop()
    }
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:TimerCell = tableView.dequeueReusableCellWithIdentifier("timerCell") as! TimerCell
        
        // load items from deal array here
        cell.refreshCell(names[indexPath.row] as! String, time: numbers[indexPath.row])
        
        return cell

    }
}



