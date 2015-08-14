//
//  ViewController.swift
//  DynamicDealsTest
//
//  Created by Nazir Shuqair on 8/10/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var lat = 38.9047
        var lng = 77.0164
        
        var json = API.getMyRestaurant(lat, lng: lng, category: "burger", price: 2)
        
        for venue in json{
            
            println(venue.1.count)
            if let deals = venue.1["deals"].array{
                
                println(deals.count)
                for deal in deals{
                    println(deal["title"])
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

