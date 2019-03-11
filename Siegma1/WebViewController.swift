
//  ViewController.swift
//  Siegma1
//
//  Created by MacBookPro on 2/7/19.
//  Copyright © 2019 MacBookPro. All rights reserved.


import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import Reachability
import SystemConfiguration
import UserNotifications
import NotificationCenter

class WebViewController: UIViewController, UIWebViewDelegate {
    
    
    //let network: NetworkManager = NetworkManager.sharedInstance
    
    
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        
        
        print(currentReachabilityStatus != .notReachable) //true connected
        
        openWeb()
        NotificationCenter.default.addObserver(self, selector: #selector(receivedUrlFromPushNotification(notification: )), name: NSNotification.Name(rawValue: "ReceivedPushNotification"), object: nil)
        //-------------------
        
        
        
        if (currentReachabilityStatus != .notReachable ){
//            openWeb(wurl: "https://www.siegma.com")
            print("connected to internet")
        }
        else{
            print("not connected to internet")
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "NoInternet" , sender: self)
            }
        }
    }
    
    @objc func receivedUrlFromPushNotification(notification: NSNotification){
        
        let JSONData = notification.object as! [String:Any]
        let url = JSONData["Link"]
        self.webView.loadRequest(NSURLRequest(url: NSURL(string:url as! String)! as URL) as URLRequest)
        
    }
    

    @objc public func openWeb(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var urlString = appDelegate.myUrl
        if urlString == "" {
            urlString = "https://www.siegma.com"
        }
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        var urlRequest = URLRequest(url: url!)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        webView.loadRequest(request)
    }
    
    
    
    @objc func catchIt(_ userInfo: Notification){
        
        if userInfo.userInfo?["Link"] != nil{
            let prefs: UserDefaults = UserDefaults.standard
            prefs.removeObject(forKey: "Link")
            prefs.synchronize()
            let url = URL(string: "Link")
            let request = URLRequest(url: url!)
            var urlRequest = URLRequest(url: url!)
            urlRequest.cachePolicy = .returnCacheDataDontLoad
            webView.loadRequest(request)
            print("line 72 app delegate")
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let prefs:UserDefaults = UserDefaults.standard
        if prefs.value(forKey: "Link") != nil{
            let userInfo: [AnyHashable: Any] = ["inactive": "inactive"]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "Link"), object: nil, userInfo: userInfo as [AnyHashable: Any])
        }
        
    }
    
}







