//
//  UserDealCell.swift
//  FareDeal
//
//  Created by Angela Smith on 7/30/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class UserDealCell: UITableViewCell, TTCounterLabelDelegate {
    
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationPhone: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var dealTitle: UILabel!
    @IBOutlet weak var dealDesc: UITextView!
    @IBOutlet weak var timeLimit: TTCounterLabel!
    @IBOutlet weak var dealValue: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setUpVenueDeal(deal: VenueDeal) {
        locationTitle.text = deal.venue.name
        locationPhone.text = deal.venue.phone
        locationImage.image = deal.venue.image
        dealTitle.text = deal.name
        dealDesc.text = deal.desc
        
        likesLabel.text = "\(deal.venue.likes)"
        favoritesLabel.text = "\(deal.venue.favorites)"
        
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
        dealValue.text = "Value: $\(valueFloat.format(valueFormat))"
    }

    
}

extension Float {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}
