//
//  Logger.swift
//  Utility
//
//  Created by Sumeet Bajaj on 11/04/2018.
//

import Foundation

public struct Logger  {
    
    #if DEBUG
    static var isDebugLogs:Bool = true
    #else
    static var isDebugLogs:Bool = false
    #endif
    
    public enum LogType:String {
        case normal = "Info"
        case error = "Error"
        case debug = "Debug"
    }
    
    static private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    /// This method will print logs only in debug mode
    ///
    /// - Parameters:
    ///   - items: Items to print
    ///   - separator: Separator between items default = " "
    ///   - terminator: Terminator after each item
    ///   - fileName: Name of file
    ///   - line: Line number
    ///   - funcName: Function Name
    public static func debug(_ items: Any?...,
                    separator: String = " ",
                    terminator: String = "\n\n",
                    fileName: String = #file,
                    line: Int = #line,
                    funcName: String = #function)
    {
        guard isDebugLogs else { return }
        
        for item in items {
            
            if let _item = item {
                let dateString = self.dateFormatter.string(from: Date())
                Swift.print(dateString,"[\(sourceFileName(filePath: fileName))]:",line,funcName," -> ",_item,
                            separator: separator,
                            terminator: terminator)
            }
        }
    }
    
    /// This method will return the name of file
    ///
    /// - Parameter filePath: FilePath of file
    /// - Returns: Name of File
    private static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
