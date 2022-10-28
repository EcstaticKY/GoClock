///
/// Created by Zheng Kanyan on 2022/10/27.
/// 
///

import Foundation

class MockTimer: Timer {
    
    enum Message {
        case fire
        case invalidate
    }
    
    var block: ((Timer) -> Void)!
    var messages: [Message]!
    
    static var currentTimers = [MockTimer]()
    
    override class func scheduledTimer(withTimeInterval interval: TimeInterval,
                                       repeats: Bool,
                                       block: @escaping (Timer) -> Void) -> Timer {
        let mockTimer = MockTimer()
        mockTimer.block = block
        
        /** Timer is bridged objective-c NSObject kind class, so it's initialization have to follow objective-c rules, and in that world only primitive type properties got default values, array is not primitive for objective-c, so skipped, thus corresponding property was uninitialised - accessing not initialised property in run-time result in crash.
         from: https://stackoverflow.com/questions/41755791/how-can-i-unit-test-swift-timer-controller
         */
        mockTimer.messages = [.fire]
        MockTimer.currentTimers.append(mockTimer)
        
        return mockTimer
    }
    
    static func tick(at index: Int = 0) {
        currentTimers[index].block(currentTimers[index])
    }
    
    override func fire() {
        messages.append(.fire)
    }
    
    override func invalidate() {
        messages.append(.invalidate)
    }
}
