//
//  ViewController.swift
//  babbleios
//
//  Created by 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 on 01/27/2023.
//  Copyright (c) 2023 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. All rights reserved.
//

import UIKit
import BabbleiOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        BabbleSdk.setCustomerId("cust007",userDetails: ["firstname":"Nirmal"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openSurveyClick(_ sender: UIButton) {
        BabbleSdk.trigger("fintech4",properties: ["firstname":"Nirmal"])
    }
    
    @IBAction func closeSurvey(_ sender: UIButton) {
        BabbleSdk.cancelSurvey()
    }
}

