//
//  UIViewExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 16/03/2018.
//

import UIKit

// Class Methods
public extension UIView {
    
    class func loadFromNib(_ nibName:String? = nil, _ bundle:Bundle) -> Self? {
        
        func instantiateFromNib<T: UIView>(_ nibName:String?,_ bundle:Bundle) -> T? {
            
            let _nibName = nibName ?? String(describing: T.self)
            
            return bundle.loadNibNamed(_nibName, owner: nil, options: nil)?.first as? T
        }
        
        return instantiateFromNib(nibName, bundle)
    }
    
    class func viewWithAccess(identifier:String) -> UIView? {
        
        for window in UIApplication.shared.windows {
            
            if let view = self.viewWithAccess(identifier: identifier, parent: window) {
                return view
            }
        }
        
        return nil
    }
    
    private class func viewWithAccess(identifier:String, parent:UIView) -> UIView? {
        
        for view in parent.subviews.reversed() {
            
            if view.accessibilityIdentifier == identifier {
                return view
            }
            else if let childView = self.viewWithAccess(identifier:identifier, parent:view) {
                
                return childView
            }
        }
        return nil
    }
}

// Instance Methods
public extension UIView {
    
    func addGradientLayer(colors:[UIColor]) {
        
        var cgColors = [CGColor]()
        
        for color in colors {
            cgColors.append(color.cgColor)
        }
        
        if cgColors.count > 0 {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.frame.size.width = UIScreen.main.bounds.size.width
            gradientLayer.colors = cgColors
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func removeAllSubViews() {
        self.subviews.forEach({
            $0.removeFromSuperview()
        })
    }
}

// Constraints
public extension UIView {
    
    func configure(on parent: UIView, insets: UIEdgeInsets = .zero, safe:Bool = false) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // adding self on parent
        parent.addSubview(self)
        
        NSLayoutConstraint.activate(self.constraints(on: parent, insets: insets, safe: safe))
    }
    
    private func constraints(on parent:UIView, insets: UIEdgeInsets, safe:Bool = false) -> [NSLayoutConstraint] {
        
        guard  #available(iOS 11.0, *), safe == true else {
            
            return [self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left),
                    self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: insets.right),
                    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
                    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: insets.bottom)]
        }
        
        return [self.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
                self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom),
                self.safeAreaLayoutGuide.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: insets.top),
                self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.trailingAnchor, constant: insets.right)]
    }
}


