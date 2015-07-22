//
//  RestaurantDealCell.swift
//  FareDeal
//
//  Created by Angela Smith on 7/22/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class RestaurantDealCell: UITableViewCell {

    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationPhone: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
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
        dealValue.text = value
    }
}
