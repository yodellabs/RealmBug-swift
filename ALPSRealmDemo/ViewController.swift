//
//  ViewController.swift
//  ALPSRealmDemo
//
//  Created by Nick Wilkerson on 12/7/17.
//  Copyright © 2017 Yodel Labs. All rights reserved.
//

import UIKit
import ALPS

class ViewController: UIViewController {

    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let beaconGetter = BeaconGetter()
        beaconGetter.connectAndFindBeacons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



