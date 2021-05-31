//
//  NSObjectExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 23/01/17.


import Foundation

public extension NSObject {
    
    // MARK:- ObjC
    private func properties(cls:AnyClass) -> [String] {
        
        var properties = [String]()
        
        var outCount : UInt32 = 0
        
        if let _properties = class_copyPropertyList(cls, &outCount) {
            
            for i in 0..<outCount {
                
                let propertyCChar = property_getName(_properties[Int(i)])
                
                if let str = String(cString: propertyCChar, encoding: .utf8) {
                    
                    properties.append(str)
                }
            }
        }
        return properties
    }
    
    private func objcClassProperties(parent:Bool = false) -> [String] {
        
        if parent == false {
            
            return self.properties(cls: self.classForCoder)
        }
        
        var classes = [AnyClass]()
        
        var currentClass:AnyClass? = self.classForCoder
        
        while currentClass != nil && currentClass != NSObject.classForCoder() {
            
            classes.append(currentClass!)
            currentClass = class_getSuperclass(currentClass)
        }
        
        var properties = [String]()
        
        for cls in classes {
            let childProperties = self.properties(cls: cls)
            properties += childProperties
        }
        
        return properties
    }
    
    // MARK:- Swift
    private func propertiesOfMirror(mirror:Mirror?, parent:Bool = false) -> [String]  {
        
        var result = [String]()
        
        if let keys =  (mirror?.children.compactMap{ $0.label }) {
            
            result = keys
        }
        
        if parent {
            
            if let superMirror = mirror?.superclassMirror  {
                
                let parentResult = self.propertiesOfMirror(mirror: superMirror, parent: parent)
                
                result += parentResult
            }
        }
      
        return result
    }

    func properties(isObjC:Bool = false, parent:Bool = false) -> [String]  {
        
        var _properties = [String]()
        
        if isObjC {

            _properties = self.objcClassProperties(parent: parent)
        }
        else {
            _properties = self.propertiesOfMirror(mirror: Mirror(reflecting: self), parent: parent)
        }
        
        return _properties
    }
    
    
    @objc func dictionary(isObjC:Bool = false, parent:Bool = false) -> [String:Any] {
        
        var info = [String:Any]()
        
        let properties = self.properties(isObjC: isObjC, parent: parent)
        
        for property in properties {
            
            if let _value = self.value(forKey: property) {
                
                info[property] = _value
            }
        }
        
        return info
    }
    
    func detailDescription(isObjC:Bool = false, parent:Bool = false) -> String {

        return "\(String(describing: self)) => \(self.dictionary(isObjC: isObjC, parent: parent))"
    }
}

fileprivate extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

public extension Array {
    func removingDuplicates<T: Hashable>(byKey key: (Element) -> T)  -> [Element] {
        var result = [Element]()
        var seen = Set<T>()
        for value in self {
            if seen.insert(key(value)).inserted {
                result.append(value)
            }
        }
        return result
    }
}

