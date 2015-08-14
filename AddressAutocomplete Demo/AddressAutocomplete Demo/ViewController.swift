//
//  ViewController.swift
//  AddressAutocomplete Demo
//
//  Created by Nazir Shuqair on 8/1/15.
//  Copyright (c) 2015 SNASTek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        let gpaViewController = GooglePlacesAutocomplete(
            apiKey: "774777853254-4fdhj12rgr3bnageerr9a5qaorcv6ua0.apps.googleusercontent.com",
            placeType: .Address
        )
        
        gpaViewController.placeDelegate = self
        
        presentViewController(gpaViewController, animated: true, completion: nil)
    
    }
    
    extension ViewController: GooglePlacesAutocompleteDelegate {
        func placeSelected(place: Place) {
            println(place.description)
        }
        
        func placeViewClosed() {
            dismissViewControllerAnimated(true, completion: nil)
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

