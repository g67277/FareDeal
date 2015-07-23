//
//  GradientLayer.swift
//  UserSide
//
//  Created by Angela Smith on 7/22/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class GradientLayer: UIView {

    
    // Subclass of uiview thal creates a vertical clear to dark grey gradient so the white text label placed over an image can be read
    private let gradient : CAGradientLayer = CAGradientLayer()
    

    override func awakeFromNib() {
        
        // Keep the gradient within the layer
        self.layer.masksToBounds = true
        
        // set up the colors
        let darkGrey = UIColor.darkGrayColor().CGColor
        let clear = UIColor.clearColor().CGColor
        
        // set gradient's color array
        gradient.colors = [clear, darkGrey]
        // add the layer to the UIView
        self.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    // Relay out subviews for auto constraints
    override func layoutSublayersOfLayer(layer: CALayer!) {
        super.layoutSublayersOfLayer(layer)
        gradient.frame = self.bounds
    }}