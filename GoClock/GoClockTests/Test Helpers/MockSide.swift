///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import Foundation
@testable import GoClock

class MockSide: ConcreteSide {
    
//    private var remainingFreeTime: TimeInterval
//    private var remainingCountDownTimes: UInt
    
    enum Message {
    case start, stop
    }
    
    var messages = [Message]()
    
    init(timeSetting: TimeSetting) {
        let timer = GoTimer(interval: 1.0, timeProvider: MockTimer.self)
        super.init(timeSetting: timeSetting, timer: timer)
    }
    
    override func start() {
        messages.append(.start)
        super.start()
    }
    
    override func stop() {
        messages.append(.stop)
        super.stop()
    }
    
    func callsUpdated(at index: Int = 0) {
        MockTimer.tick(at: index)
    }
}
