//
//  Notifier.swift
//  Utility
//
//  Created by Sumeet Bajaj on 02/07/2019.
//

import Foundation

public protocol Notifier {
    associatedtype Notification: RawRepresentable
}

public extension Notifier {
    
    private static func nameFor(notification: Notification) -> String {
        return "\(self).\(notification.rawValue)"
    }
    
    static func addObserver(observer: AnyObject, selector: Selector, notification: Notification) {
       
        let name = nameFor(notification: notification)
        
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    static func postNotification(notification: Notification, object: AnyObject? = nil, userInfo: [String : Any]? = nil) {
        
        let name = nameFor(notification: notification)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: userInfo)
    }
    
    static func removeObserver(observer: AnyObject, notification: Notification, object: AnyObject? = nil) {
        
        let name = nameFor(notification: notification)
        
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
    }
}
