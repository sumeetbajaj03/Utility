//
//  HTMLParser.swift
//  Utility
//
//  Created by Sumeet Bajaj on 24/03/2020.
//

import Foundation
public struct HTMLParser {
    
    let string: String?
    
    public init(value: String?) {
        self.string = value
    }
    public func getValues(tag:String) -> [Substring] {
        
        return string?.slices(from: "\(tag)=\"", to: "\"") ?? [Substring]()
    }
    public func getTitleOfhref() -> [Substring] {
        return string?.slices(from: ">", to: "<") ?? [Substring]()
    }
    
    public func getBody(tag:String) -> [Substring] {
        return string?.slices(from: "<\(tag)", to: "/\(tag)>") ?? [Substring]()
    }
}
