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
        
        if (currentReachabilityStatus != .notReachable ){
////            self.performSegue(withIdentifier: "TryAgain", sender: nil)
//            self.present(WebViewController(), animated: true, completion: nil)
////            WebViewController().openWeb()
            performSegue(withIdentifier: "TryAgain", sender: nil)
            print("connected to internet")
        }
        else{
            print("not connected to internet")
            OperationQueue.main.addOperation {
            self.present(NoConnectionViewController(), animated: true, completion: nil)
            super.viewDidAppear(true)
            }

            
        }
        }
    }



