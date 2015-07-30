//
//  DealsCell.swift
//  FareDeal
//
//  Created by Nazir Shuqair on 7/18/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class DealsCell: UITableViewCell {
    
    @IBOutlet weak var dealTitle: UILabel!
    @IBOutlet weak var dealDesc: UITextView!
    @IBOutlet weak var timeLimit: UILabel!
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
    
    func refreshCell(title: String, desc: String, time: Int, value: String){
        
        dealTitle.text = title
        dealDesc.text = desc
        if time < 2 {
            timeLimit.text = "\(time)hr"
        }else{
            timeLimit.text = "\(time)hrs"
        }
        dealValue.text = value
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
