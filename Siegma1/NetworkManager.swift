
//  ReachabilityManage.swift
//  Siegma1
//  Created by MacBookPro on 2/7/19.
//  Copyright © 2019 MacBookPro. All rights reserved.


import Foundation
import Reachability
import SystemConfiguration

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }

}
//
//
//
//class ReachabilityManager: NSObject {
//
//
//
//    var reachability: Reachability?
//    let reachabilityChangedNotification = "ReachabilityChangedNotification"
//    let errorManager = ErrorManager()
//
//
//
//    class var sharedManager: ReachabilityManager {
//        struct Static {
//            static var onceToken: dispatch_once_t = 0
//            static var instance: ReachabilityManager? = nil
//        }
//        dispatch_once(&Static.onceToken) {
//            Static.instance = ReachabilityManager()
//        }
//
//        return Static.instance!
//    }
//    
//    //MARK: - Lifecycle
//
//    override init() {
//        super.init()
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReachabilityManager.reachabilityChanged), name: reachabilityChangedNotification, object: reachability)
//        do {
//            self.reachability = try Reachability.reachabilityForInternetConnection()
//            try self.reachability?.startNotifier()
//        } catch {
//            logger.info("\(APPNAME) Reachability failed")
//            return
//        }
//    }
//
//    @objc func reachabilityChanged(notification: NSNotification) {
//        weak var weakSelf = self
//        let reachability = notification.object as! Reachability
//
//        if reachability.isReachable() {
//            logger.info("\(APPNAME) Reachability: Reachable")
//        } else {
//            weakSelf?.errorManager.handleReachability()
//            logger.info("\(APPNAME) Reachability: Not reachable")
//        }
//    }
//

//    //MARK: - Class Methods
//
//    static func isReachable() -> Bool{
//        return ReachabilityManager.sharedManager.reachability!.isReachable()
//    }
//    
//    static func isUnreachable() -> Bool {
//        return !(ReachabilityManager.sharedManager.reachability!.isReachable())
//    }
//
//    static func isReachableViaWWAN() -> Bool{
//        return ReachabilityManager.sharedManager.reachability!.isReachableViaWWAN()
//    }
//    
//    static func isReachableViaWiFi() ->Bool{
//        return ReachabilityManager.sharedManager.reachability!.isReachableViaWiFi()
//    }
//    
//}
//
