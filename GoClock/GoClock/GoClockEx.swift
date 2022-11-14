//
//  GoClockEx.swift
//  GoClock
//
//  Created by zky on 2022/11/14.
//

import Foundation

public class GoClockEx {
    public enum State: Equatable {
        case ready, running(atHost: Bool), pausing(atHost: Bool), timedOut
    }
    
    public enum RemainingTime: Equatable {
        case free(seconds: UInt)
        case countDown(seconds: UInt, times: UInt)
    }
    
    public private(set) var state = State.ready
    public var hostRemainingTime: RemainingTime
    public var guestRemainingTime: RemainingTime
    
    private let timeSetting: TimeSetting
    private let timeProvider: Timer.Type
    private var timer: Timer?
    
    public init(timeSetting: TimeSetting, timeProvider: Timer.Type = Timer.self) {
        self.timeSetting = timeSetting
        self.timeProvider = timeProvider
        hostRemainingTime = .free(seconds: timeSetting.freeTimeSeconds)
        guestRemainingTime = .free(seconds: timeSetting.freeTimeSeconds)
    }
    
    @discardableResult
    public func start() -> Bool {
        guard case .ready = state else {
            return false
        }
        timer = timeProvider.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            
        })
        state = .running(atHost: true)
        return true
    }
    
    @discardableResult
    public func switchSide() -> Bool {
        guard case .running(let atHost) = state else {
            return false
        }
        
        timer?.invalidate()
        timer = timeProvider.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            
        })
        
        state = .running(atHost: !atHost)
        return true
    }
    
    @discardableResult
    public func pause() -> Bool {
        guard case .running(let atHost) = state else {
            return false
        }
        
        timer?.invalidate()
        state = .pausing(atHost: atHost)
        return true
    }
    
    @discardableResult
    public func resume() -> Bool {
        guard case .pausing(let atHost) = state else {
            return false
        }
        
        timer = timeProvider.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            
        })
        state = .running(atHost: atHost)
        return true
    }
    
    @discardableResult
    public func reset() -> Bool {
        guard case .pausing = state else {
            return false
        }
        
        state = .ready
        return true
    }
}
