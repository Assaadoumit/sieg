//
//  ViewController.swift
//  Siegma1
//
//  Created by MacBookPro on 2/7/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    
    
    
    override func viewDidLoad() {
        openWeb()
        webViewError(UIWebViewController, didFailLoadWithError: Error)
    }
  
    func webViewError(_ webView: UIWebView,
                      didFailLoadWithError error: Error){
        print("error loading page")
        performSegue(withIdentifier: "NoInternet", sender: nil)
    }
    func openWeb(){ let url = URL(string: "https://www.siegma.com")
        let request = URLRequest(url: url!)
        var urlRequest = URLRequest(url: url!)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        webView.loadRequest(request)
    }}
