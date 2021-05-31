//
//  BundleExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 11/07/2019.
//

import Foundation

public extension Bundle {
    
    static func loadJSON(for aClass: AnyClass, fileName name:String) -> Any? {
        
        if let path = Bundle(for: aClass).path(forResource: name, ofType: "json") {
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                return try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            }
            catch {
                Logger.debug(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    var version: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var appVersion: String? {
        guard let version = self.version, let buildVersion = self.buildVersion else {
            return nil
        }
        
        return version + "." + buildVersion
    }
}
