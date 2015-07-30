//
//  RestaurantDealCell.swift
//  FareDeal
//
//  Created by Angela Smith on 7/22/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class RestaurantDealCell: UITableViewCell, TTCounterLabelDelegate {
    
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationPhone: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var dealTitle: UILabel!
    @IBOutlet weak var dealDesc: UITextView!
    @IBOutlet weak var timeLimit: TTCounterLabel!
    @IBOutlet weak var dealValue: UILabel!
    
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
    
    func setUpCell(name: String, phone: String, image: UIImage, title: String, desc: String, time: Int, value: String){
        
        locationTitle.text = name
        locationPhone.text = phone
        locationImage.image = image
        dealTitle.text = title
        dealDesc.text = desc
        if time < 2 {
            timeLimit.text = "\(time)hr time limit"
        }else{
            timeLimit.text = "\(time)hrs time limit"
        }
        //dealValue.text = value
    }
    
    func setUpRestaurantDeal(restaurant: Restaurant, deal: Deals) {
        locationTitle.text = restaurant.name
        locationPhone.text = restaurant.phone
        locationImage.image = UIImage (named: restaurant.imageName)!
        dealTitle.text = deal.name
        dealDesc.text = deal.desc
        
        // Set up the timer countdown label
        var timeLength: UInt64 = 3600000
        switch deal.timeLimit {
        case 2 :
            timeLength = 7200000
        case 3 :
            timeLength = 10800000
        default:
            timeLength = 3600000
        }
        
        timeLimit.countDirection = 1
        timeLimit.startValue = timeLength
        timeLimit.start()
        
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