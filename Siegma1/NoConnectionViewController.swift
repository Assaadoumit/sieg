//
//  NoConnectionViewController.swift
//  Siegma1
//
//  Created by MacBookPro on 3/4/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit
import SystemConfiguration
import Alamofire
import Reachability

class NoConnectionViewController: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func TryAgain(_ sender: Any) {
//        performSegue(withIdentifier: "TryAgain", sender: nil)
        if (currentReachabilityStatus != .notReachable ){
            performSegue(withIdentifier: "TryAgain", sender: nil)
//            WebViewController().openWeb()
            print("connected to internet")
        }
        else{
            print("not connected to internet")
            OperationQueue.main.addOperation {
//          self.performSegue(withIdentifier: "NoInternet" , sender: nil)
            super.viewDidAppear(true)
            }
        }
    }
}


