//
//  KolodaPhotoView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 8/20/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Concorde


class KolodaPhotoView: UIView {

    @IBOutlet var photoTitleLabel: UILabel?
    @IBOutlet var photoView: UIView!
    @IBOutlet var photoImageView: AsyncImageView!
    
    /*
    @IBOutlet lazy var photoImageView: AsyncImageView! = {
        [unowned self] in
        
        var imageView = CCBufferedImageView(frame: self.photoView.bounds)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        self.photoView.addSubview(imageView)
        
        return imageView
        }()
    
    // Relay out subviews for auto constraints
    override func layoutSublayersOfLayer(layer: CALayer!) {
        super.layoutSublayersOfLayer(layer)
        photoImageView.frame = self.photoView.bounds
        photoImageView.roundCorners((UIRectCorner.TopLeft|UIRectCorner.TopRight), radius: 14)
        photoTitleLabel!.roundCorners((.BottomLeft  | .BottomRight), radius: 14)
    }*/

}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
    
    func setBorder() {
        //self.layer.borderColor = UIColor.lightGrayColor().CGColor
        //self.layer.borderWidth = 1.0
        
        // drop shadow
        self.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 1.3
        self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
    }
}

