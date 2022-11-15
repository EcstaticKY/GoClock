//
//  GoClock.swift
//  GoClock
//
//  Created by zky on 2022/11/14.
//

import Foundation

public let DefaultInterval = 0.1

public class GoClock {
    public enum State: Equatable {
        case ready, running(atHost: Bool), pausing(atHost: Bool), timedOut(atHost: Bool)
    }
    
    public private(set) var state = State.ready {
        didSet {
            updated?()
        }
    }
    public var hostRemainingTime: RemainingTime
    public var guestRemainingTime: RemainingTime
    
    private let interval: TimeInterval
    private let timeSetting: TimeSetting
    private let timeProvider: Timer.Type
    private var timer: Timer?
    private var updated: (() -> Void)?
    
    public init(timeSetting: TimeSetting,
                interval: TimeInterval = DefaultInterval,
                timeProvider: Timer.Type = Timer.self) {
        self.timeSetting = timeSetting
        self.timeProvider = timeProvider
        self.interval = interval
        hostRemainingTime = RemainingTime(timeSetting: timeSetting)
        guestRemainingTime = RemainingTime(timeSetting: timeSetting)
    }
    
    public func setUpdatedBlock(_ block: @escaping () -> Void) {
        updated = block
    }
    
    @discardableResult
    public func start() -> Bool {
        guard case .ready = state else {
            return false
        }
        
        hostRemainingTime.secondsUpdated = { [weak self] in
            guard let self = self else { return }
            if self.hostRemainingTime.remainingCountDownTimes <= 0 {
                self.timer?.invalidate()
                self.state = .timedOut(atHost: true)
            }
            self.updated?()
        }
        guestRemainingTime.secondsUpdated = { [weak self] in
            guard let self = self else { return }
            if self.guestRemainingTime.remainingCountDownTimes <= 0 {
                self.timer?.invalidate()
                self.state = .timedOut(atHost: false)
            }
            self.updated?()
        }
        
        state = .running(atHost: true)
        fireTimer(atHost: true)
        
        return true
    }
    
    @discardableResult
    public func switchSide() -> Bool {
        guard case .running(var atHost) = state else {
            return false
        }
        
        timer?.invalidate()
        
        atHost.toggle()
        state = .running(atHost: atHost)
        fireTimer(atHost: atHost)
        
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
        
        state = .running(atHost: atHost)
        fireTimer(atHost: atHost)
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
    
    private func fireTimer(atHost: Bool) {
        timer = timeProvider.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            if atHost {
                self.hostRemainingTime.tick(interval: self.interval)
            } else {
                self.guestRemainingTime.tick(interval: self.interval)
            }
        })
    }
}
