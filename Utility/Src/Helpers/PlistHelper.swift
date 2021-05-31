//
//  PlistHelper.swift
//  Utility
//
//  Created by Sumeet Bajaj on 04/11/2020.
//

import Foundation


public class PlistHelper {
    
    public class func fetchInfoOfFileName(_ name:String, bundle:Bundle? = .main ) -> [String:Any]? {
        
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        
        guard let plistPath = bundle?.path(forResource: name, ofType: "plist"),
            FileManager.default.fileExists(atPath: plistPath) == true else {
                // file not found error
                return nil
        }
        
        guard  let plistXML = FileManager.default.contents(atPath: plistPath) else {
            // failed to load content of file
            return nil
        }
        
        do {//convert the data to a dictionary and handle errors.
            let plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as? [String:Any]
            return plistData
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        
        return nil
    }
}
