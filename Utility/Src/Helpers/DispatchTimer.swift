//
//  DispatchTimer.swift
//  Utility
//
//  Created by Sumeet Bajaj on 01/04/2020.
//

import Foundation

public struct DispatchTimer {
    
    static private let queue = DispatchQueue(label: "DispatchTimerQueue")
    
    public typealias DTEventHandler = (() -> Void)
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var interval: TimeInterval = 10
    private var handler:DTEventHandler?
    private var state: State = .suspended
    
    public init(interval: TimeInterval = 10,  handler:DTEventHandler?) {
        self.interval = interval
        self.handler = handler
        self.resume()
    }

    private lazy var timer: DispatchSourceTimer? = {
        
        let t = DispatchSource.makeTimerSource(queue: DispatchTimer.queue)
        t.schedule(deadline: .now() + self.interval, repeating: self.interval)
        t.setEventHandler(handler: self.handler)
        return t
    }()
    
    public mutating func resume() {
        if self.state == .resumed {
            return
        }
        self.state = .resumed
        self.timer?.resume()
    }
    
    public mutating func suspend() {
        if state == .suspended {
            return
        }
        self.state = .suspended
        self.timer?.suspend()
    }
    
    public mutating func cancel() {
        
        self.timer?.cancel()
  
        self.timer?.setEventHandler(handler: nil)
        self.timer = nil
        self.handler = nil
    }
}
