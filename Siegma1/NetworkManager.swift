
//  ReachabilityManage.swift
//  Siegma1
//  Created by MacBookPro on 2/7/19.
//  Copyright © 2019 MacBookPro. All rights reserved.


//import Foundation
//import Reachability
//
//
//class NetworkManager: NSObject {
//
//    var reachability: Reachability!
//
//    // Create a singleton instance
//    static let sharedInstance: NetworkManager = { return NetworkManager() }()
//
//
//    override init() {
//        super.init()
//
//        // Initialise reachability
//        reachability = Reachability()!
//
//        // Register an observer for the network status
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(networkStatusChanged(_:)),
//            name: .reachabilityChanged,
//            object: reachability
//        )
//
//        do {
//            // Start the network status notifier
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
//    }
//
//    @objc func networkStatusChanged(_ notification: Notification) {
//        // Do something globally here!
//    }
//
//    static func stopNotifier() -> Void {
//        do {
//            // Stop the network status notifier
//            try (NetworkManager.sharedInstance.reachability).startNotifier()
//        } catch {
//            print("Error stopping notifier")
//        }
//    }
//
//    // Network is reachable
//    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
//        if (NetworkManager.sharedInstance.reachability).connection != .none {
//            completed(NetworkManager.sharedInstance)
//        }
//    }
//
//    // Network is unreachable
//    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
//        if (NetworkManager.sharedInstance.reachability).connection == .none {
//            completed(NetworkManager.sharedInstance)
//        }
//    }
//
//    // Network is reachable via WWAN/Cellular
//    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
//        if (NetworkManager.sharedInstance.reachability).connection == .cellular {
//            completed(NetworkManager.sharedInstance)
//        }
//    }
//
//    // Network is reachable via WiFi
//    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
//        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
//            completed(NetworkManager.sharedInstance)
//        }
//    }
//
//
//}
//
//

import SystemConfiguration


protocol Utilities {
}

extension NSObject:Utilities{
    
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
}
