//
//  StringExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 27/06/2019.
//

import Foundation

public extension String {
    
    func jsonObject() -> Result<Any,Error> {
        
        guard let data = self.data(using: .utf8) else {

            return .failure("Failed to covert string in data.\(self)".localizedDescription)
        }
        
        return data.jsonObject()
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

public extension String {
    
    func localized(comment:String = "") -> String {
    
        return NSLocalizedString(self, comment: comment)
    }
}


public extension String {
    
    func htmlToAttributedString(attrs:[NSAttributedString.Key:Any]?) -> Result<NSAttributedString,Error> {
        
        guard let htmlData = self.data(using: .unicode) else {
            
            return .failure("Failed converting to data".localizedDescription)
        }
        
        do {
            
            
            let attStr = try NSMutableAttributedString(data: htmlData,
                                                       options: [.documentType: NSAttributedString.DocumentType.html],
                                                       documentAttributes: nil)
            
            if let _attrs = attrs {
                attStr.addAttributes(_attrs, range: NSRange(location: 0, length: attStr.length))
            }
        
            return .success(attStr)
        }
        catch {
            return .failure(error)
        }
    }
}

public extension String {
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    func slices(from: String, to: String) -> [Substring] {
        let pattern = "(?<=" + from + ").*?(?=" + to + ")"
        return ranges(of: pattern, options: .regularExpression)
            .map{ self[$0] }
    }
}
