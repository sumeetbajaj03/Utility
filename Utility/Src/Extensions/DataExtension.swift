//
//  DataExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 31/08/2018.
//

import Foundation

public extension Data {
        
    func jsonObject() -> Result<Any, Error> {
        do {
            let obj = try JSONSerialization.jsonObject(with: self, options: .init(rawValue: 0))
            return .success(obj)
        }
        catch {
            return .failure(error)
        }
    }
    
    func jsonString() -> String? {
        
        return String(data: self, encoding: .utf8)
    }
}

public extension Data {

    func jsonDecoder<T>(_ type: T.Type) -> Result<T, Error> where T:Decodable {
        
        do {
            let item = try JSONDecoder().decode(type, from: self)
            return .success(item)
        }
        catch {
            return .failure(error)
        }
    }
}
