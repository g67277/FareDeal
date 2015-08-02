//
//  CardContentView.swift
//  FareDeal
//
//  Created by Angela Smith on 7/20/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

// This view recieves the restaurant name, image, and phone number and displays it as a UIView over the Koloda view


import UIKit

class CardContentView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        // Shadow
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.33
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        // Corner Radius
        layer.cornerRadius = 10.0;
    }
    
    func setUpRestaurant(contentView: UIView, dataObject: Restaurant){
        
        let restaurant: Restaurant = dataObject
        if let label = contentView.viewWithTag(10) as? UILabel {
            label.text = restaurant.name
        }
        if let phoneLabel = contentView.viewWithTag(15) as? UILabel {
            phoneLabel.text = restaurant.phone
        }
        //var imageName = restaurant.imageName
        if let locationImage = contentView.viewWithTag(20) as? UIImageView {
                locationImage.contentMode = UIViewContentMode.ScaleAspectFill
                locationImage.clipsToBounds = true
                locationImage.image = restaurant.image
        }
    }
    
}
