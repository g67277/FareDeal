//
//  ViewController.swift
//  Attributed Detail Test
//
//  Created by Angela Smith on 8/12/15.
//  Copyright (c) 2015 Angela Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textView: LinkedTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textView.text = "240 Flying Cloud Drive, Chaska MN 55318"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

