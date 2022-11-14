//
//  RemainingTime.swift
//  GoClock
//
//  Created by zky on 2022/11/14.
//

import Foundation

public class RemainingTime: Equatable {
    
    init(timeSetting: TimeSetting) {
        timeInterval = TimeInterval(timeSetting.freeTimeSeconds)
        totalCountDownSeconds = timeSetting.countDownSeconds
        remainingCountDownTimes = timeSetting.countDownTimes
    }
    
    private var timeInterval: TimeInterval
    var secondsUpdated: (() -> Void)?
    
    public private(set) var stillFree = true
    public var currentSeconds: UInt {
        let seconds = currentSecondsInInt()
        return seconds >= 0 ? UInt(seconds) : 0
    }
    public let totalCountDownSeconds: UInt
    public var remainingCountDownTimes: UInt
    
    func tick(interval: TimeInterval) {
        timeInterval -= interval
        if abs(timeInterval - Double(currentSecondsInInt())) < interval / 2 {
            if currentSecondsInInt() < 0 {
                timeInterval = TimeInterval(totalCountDownSeconds)
                if stillFree {
                    stillFree = false
                } else {
                    remainingCountDownTimes -= 1
                }
            }
            secondsUpdated?()
        }
    }
    
    private func currentSecondsInInt() -> Int {
        let seconds = floor(timeInterval)
        return timeInterval - seconds < DefaultInterval / 2 ? Int(seconds) : Int(seconds) + 1
    }
    
    public static func == (lhs: RemainingTime, rhs: RemainingTime) -> Bool {
        lhs.currentSeconds == rhs.currentSeconds &&
        lhs.totalCountDownSeconds == rhs.totalCountDownSeconds &&
        lhs.remainingCountDownTimes == rhs.remainingCountDownTimes
    }
}
