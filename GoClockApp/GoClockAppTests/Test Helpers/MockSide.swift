///
/// Created by Zheng Kanyan on 2022/10/28.
///
///

import Foundation
import GoClock

class MockSide: Side {
    var timeSetting: TimeSetting
    
    var remainingTime: (freeTimeSeconds: UInt, countDownTimes: UInt) {
        (UInt(remainingFreeTime), remainingCountDownTimes)
    }
    
    private var remainingFreeTime: TimeInterval
    private var remainingCountDownTimes: UInt
    
    enum Message {
    case start, stop
    }
    
    var messages = [Message]()
    var updated: (() -> Void)?
    
    init(timeSetting: TimeSetting) {
        self.timeSetting = timeSetting
        remainingFreeTime = TimeInterval(timeSetting.freeTimeSeconds)
        remainingCountDownTimes = timeSetting.countDownTimes
    }
    
    func setUpdatedClosure(_ updated: @escaping () -> Void) {
        self.updated = updated
    }
    
    func start() {
        messages.append(.start)
    }
    
    func stop() {
        messages.append(.stop)
    }
    
    func callsUpdated() {
        remainingFreeTime -= 1
        updated?()
    }
}
