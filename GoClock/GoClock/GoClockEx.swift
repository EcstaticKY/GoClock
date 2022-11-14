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
    
    public init(timeSetting: TimeSetting) {
        self.timeSetting = timeSetting
        hostRemainingTime = .free(seconds: timeSetting.freeTimeSeconds)
        guestRemainingTime = .free(seconds: timeSetting.freeTimeSeconds)
    }
    
    @discardableResult
    public func start() -> Bool {
        state = .running(atHost: true)
        return true
    }
    
    @discardableResult
    public func switchSide() -> Bool {
        guard case .running(let atHost) = state else {
            return false
        }
        
        state = .running(atHost: !atHost)
        return true
    }
    
    @discardableResult
    public func pause() -> Bool {
        guard case .running(let atHost) = state else {
            return false
        }
        
        state = .pausing(atHost: atHost)
        return true
    }
    
    @discardableResult
    public func resume() -> Bool {
        guard case .pausing(let atHost) = state else {
            return false
        }
        
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
