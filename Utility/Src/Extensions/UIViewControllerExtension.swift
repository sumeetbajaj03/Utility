//
//  UIViewControllerExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 28/01/2020.
//

import UIKit

public extension UIViewController {
    
    class func loadFromNib(_ bundle:Bundle? = nil) -> Self {
        
        func instantiateFromNib<T: UIViewController>(bundle:Bundle?) -> T {
            
            let _bundle = bundle ?? Bundle(for: T.self)
            
            return T.init(nibName: String(describing: T.self), bundle: _bundle)
        }
        
        return instantiateFromNib(bundle: bundle)
    }
    
    class func initialise(storyboard name:String, bundle:Bundle, identifier:String) -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: name, bundle: bundle)
        
        return storyBoard.instantiateViewController(withIdentifier: identifier)
    }
    
    func configureChildViewController(childController: UIViewController, onView : UIView) {
        addChild(childController)
        onView.addSubview(childController.view)
        constrainViewEqual(holderView: onView, view: childController.view)
        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
    }
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        //pin 100 points from the top of the super
        view.leadingAnchor.constraint(equalTo: holderView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: holderView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: holderView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: holderView.bottomAnchor).isActive = true
    }
}


// Alert
public extension UIViewController {
    
    func showAlert(_ title:String?, _ message:String? , _ actions:[UIAlertAction]? = nil) {
        
        DispatchQueue.main.async {
            
            guard self.presentedViewController == nil else {
                Logger.debug("Already presented \(String(describing: self.presentedViewController))")
                return
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            actions?.forEach({ (action) in
                alertController.addAction(action)
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
