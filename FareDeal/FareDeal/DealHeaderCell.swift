//
//  DealHeaderCell.swift
//  BiddingCountdownTest
//
//  Created by Angela Smith on 7/30/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class DealHeaderCell: UITableViewCell, TTCounterLabelDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet weak var timeLimit: TTCounterLabel!
    @IBOutlet var searchView: UIView!
    @IBOutlet var priceView: UIView!

    
    func setUpVenueDeal(deal: VenueDeal) {

        priceView.roundCorners(.AllCorners, radius: 10)
        searchView.roundCorners(.AllCorners, radius: 10)
        
        titleLabel.text = deal.name
        descLabel.text = deal.desc
        
        // Set up the timer countdown label
        let now = NSDate()
        let expires = deal.expirationDate
        let calendar = NSCalendar.currentCalendar()
        let datecomponenets = calendar.components(NSCalendarUnit.CalendarUnitSecond, fromDate: now, toDate: expires, options: nil)
        let seconds = datecomponenets.second * 1000
        println("Seconds: \(seconds) times 1000")
        timeLimit.countDirection = 1
        timeLimit.startValue = UInt64(seconds)
        timeLimit.start()
        if seconds <= 0 {
            timeLimit.stop()
        }
        
        // Set up the value
        let valueFloat:Float = deal.value, valueFormat = ".2"
        valueLabel.text = "Value: $\(valueFloat.format(valueFormat))"
    }
    

}


