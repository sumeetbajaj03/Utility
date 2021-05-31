//
//  DictionaryExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 31/08/2018.
//

import Foundation

public extension Dictionary {
    
    func data() -> Data? {
        
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .init(rawValue: 0))
        }
        catch {
            Logger.debug("Failed to convert in data: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func jsonString() -> String? {
        
        guard let data = self.data() else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
