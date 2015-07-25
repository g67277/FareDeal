//
//  TimerCell.swift
//  TimerTest
//
//  Created by Angela Smith on 7/24/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class TimerCell: UITableViewCell, TTCounterLabelDelegate {

    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var numberTitle: TTCounterLabel!
    
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
    
    func refreshCell(title: String, time: Int){
        var timeLength: UInt64 = 3600000
        switch time {
        case 2 :
            timeLength = 7200000
        case 3 :
            timeLength = 10800000
        default:
            timeLength = 3600000
        }

        numberTitle.countDirection = 1
        numberTitle.startValue = timeLength
        numberTitle.start()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
