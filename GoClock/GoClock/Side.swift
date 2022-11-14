///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import Foundation

public struct TimeSetting {
    public init(freeTimeSeconds: UInt, countDownSeconds: UInt, countDownTimes: UInt) {
        self.freeTimeSeconds = freeTimeSeconds
        self.countDownSeconds = countDownSeconds
        self.countDownTimes = countDownTimes
    }
    
    public let freeTimeSeconds: UInt
    public let countDownSeconds: UInt
    public let countDownTimes: UInt
}

public class ConcreteSide {
    
    public let timeSetting: TimeSetting
    public var remainingTime: (freeTimeSeconds: UInt, countDownTimes: UInt) {
        let seconds = floor(remainingFreeTime)
        let freeTimeSeconds = remainingFreeTime - seconds < DefaultInterval / 2 ? UInt(seconds) : UInt(seconds) + 1
        return (freeTimeSeconds, remainingCountDownTimes)
    }
    
    private var remainingFreeTime: TimeInterval
    private var remainingCountDownTimes: UInt
    
    private let timer: GoTimer
    private var updated: (() -> Void)?
    
    public init(timeSetting: TimeSetting, timer: GoTimer) {
        self.timer = timer
        self.timeSetting = timeSetting
        remainingFreeTime = TimeInterval(timeSetting.freeTimeSeconds)
        remainingCountDownTimes = timeSetting.countDownTimes
        
        timer.setTickedClosure { [weak self] interval in
            guard let self = self else { return }
            self.remainingFreeTime -= interval
            if abs(self.remainingFreeTime - Double(self.remainingTime.freeTimeSeconds)) < DefaultInterval / 2 {
                if self.remainingTime.freeTimeSeconds == 0 {
                    self.timer.invalidate()
                }
                self.updated?()
            }
        }
    }
    
    public func setUpdatedClosure(_ updated: @escaping () -> Void) {
        self.updated = updated
    }
    
    public func start() {
        guard remainingTime.freeTimeSeconds > 0 || abs(remainingFreeTime - Double(remainingTime.freeTimeSeconds)) > DefaultInterval / 2 else {
            return
        }
        timer.fire()
    }
    
    public func stop() {
        timer.invalidate()
    }
}
