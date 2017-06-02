//
//  ViewController.swift
//  NativeExpressRow
//
//  Created by Admin on 27.05.17.
//  Copyright © 2017 PS. All rights reserved.
//

import UIKit
import Eureka

class ViewController: FormViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< NativeExpressRow() {
                $0.value = "your-admob-unit-id"
                $0.adHeight = 132.0
            }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

