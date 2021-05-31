//
//  DateExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 10/06/2020.
//

import Foundation

// MARK:- DotNet Ticks constants
private let CTicks : Double = 62_135_596_800
private let CTicksPerSecond : Double = 10_000_000
private let CTicksMinValue : UInt64 = 0
private let CTicksMaxValue : UInt64 = 3_155_378_975_999_999_999

//MARK:- DotNet Ticks Implementation
public extension Date {
    
    init(ticks: UInt64) {
        self.init(timeIntervalSince1970: Double(ticks)/CTicksPerSecond - CTicks)
    }
    
    var ticks: UInt64 {
        
        if self == Date.distantPast {
            return CTicksMinValue
        }
        
        if self == Date.distantFuture {
            return CTicksMaxValue
        }
        
        return UInt64((self.timeIntervalSince1970 + CTicks) * CTicksPerSecond)
    }
}
