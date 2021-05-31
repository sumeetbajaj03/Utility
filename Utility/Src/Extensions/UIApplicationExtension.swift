//
//  UIApplicationExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 19/08/2020.
//

import UIKit

public extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        // If the app embedded with Navigation Controller
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        // If the app using TabBar based controller
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        // Fetching presented controller from root view controller
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        // If nothing found then returning the UIApplication's root view Controller.
        return controller
    }
}
