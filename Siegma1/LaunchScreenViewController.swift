//
//  LaunchScreenViewController.swift
//  Siegma1
//
//  Created by MacBookPro on 3/13/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let newViewController = WebViewController()
            self.present(newViewController, animated: true, completion: nil)
        })
    }
  

}
