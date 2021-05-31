//
//  Toast.swift
//  Utility
//
//  Created by Sumeet Bajaj on 16/10/2019.


import Foundation
import UIKit

fileprivate class ToastLabel: UILabel {

    var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInset.left + contentInset.right,
                      height: size.height + contentInset.top + contentInset.bottom)
    }
    
    override func drawText(in rect: CGRect) {
    
        super.drawText(in: rect.inset(by: contentInset))
    }
}

fileprivate struct ToastMessage {
    var body:String
    var type:Toast.ToastType
}
 
public class Toast {
    
    public enum ToastType:String {
        
        case normal = "normal"
        case error = "error"
        
        internal func interval() -> TimeInterval {
            
            return self == .error ? 5 : 1.5
        }
    }
    
    private static var label:UILabel?
    private static var timer: Timer?
    private static var queue:[ToastMessage]?
    public static var isDebugEnabled:Bool = false
    
    public class func showDebug(message:String, type:ToastType = .normal) {
        
        guard self.isDebugEnabled == true else { return }
        
        self.show(message: message, type: type)
    }
    
    public class func show(message:String, type:ToastType = .normal) {
        
        DispatchQueue.main.async {
            
            if self.label == nil, let _aView =  UIApplication.shared.delegate?.window as? UIView {
                self.label = label(view: _aView)
                self.updateText(msg: ToastMessage(body: message, type: type))
            }
            else {
                if self.queue == nil {
                    self.queue = [ToastMessage]()
                }
                self.queue?.append(ToastMessage(body: message, type: type))
            }
        }
    }
    
    public class func hide(animated:Bool) {
        
        if animated {
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                        self.label?.alpha = 0
            }) { (state) in
                    self.clean()
            }
        }
        else  {
            self.clean()
        }
    }
    
    private class func clean() {
        
        DispatchQueue.main.async {
          // clean local properties
          // clear timer
          self.timer?.invalidate()
          self.timer = nil
          // clear label
          self.label?.removeFromSuperview()
          self.label = nil

          self.queue?.removeAll()
          self.queue = nil
        }
    }
    
    private class func updateText(msg:ToastMessage) {
        
        if let _label = self.label {
                      
            _label.superview?.bringSubviewToFront(_label)
            _label.text = msg.body
            _label.textColor = msg.type == .normal ? .white : .red
            
            let duration:TimeInterval = msg.type.interval()
            
            self.timer?.invalidate()
            self.timer = nil
            
            self.timer = Timer.scheduledTimer(timeInterval: duration,
                                              target: self,
                                              selector: #selector(hideIfNeeded),
                                              userInfo: nil,
                                              repeats: false)
        }
    }

    private class func label(view:UIView) -> UILabel? {
    
        let _label = ToastLabel(frame: .zero)
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.numberOfLines = 0
        _label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        _label.textColor = .white
        _label.font = UIFont.systemFont(ofSize: 12)
        _label.layer.cornerRadius = 10
        _label.clipsToBounds = true
        _label.textAlignment = .left
        _label.accessibilityIdentifier = "ToastLabel"
        _label.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right:5)
        _label.layer.zPosition = .greatestFiniteMagnitude
        view.addSubview(_label)
        view.bringSubviewToFront(_label)
        
        if #available(iOS 11.0, *) {
            _label.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
            _label.safeAreaLayoutGuide.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
            _label.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
            _label.safeAreaLayoutGuide.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        }
        else {
            _label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            _label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 8).isActive = true
            _label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            _label.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        }
        
        return _label
    }
    
    @objc private class func hideIfNeeded() {
        
        if self.queue?.count ?? 0 > 0, let message = self.queue?.removeFirst() {
         
            self.updateText(msg: message)
            return
        }
        
        self.hide(animated: true)
    }
}
