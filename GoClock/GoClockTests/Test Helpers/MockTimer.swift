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
    static var messages = [Message]()
    
    static var currentTimers = [MockTimer]()
    
    override class func scheduledTimer(withTimeInterval interval: TimeInterval,
                                       repeats: Bool,
                                       block: @escaping (Timer) -> Void) -> Timer {
        let mockTimer = MockTimer()
        mockTimer.block = block
        
        MockTimer.messages.append(.fire)
        MockTimer.currentTimers.append(mockTimer)
        
        return mockTimer
    }
    
    static func tick(at index: Int = 0) {
        currentTimers[index].block(currentTimers[index])
    }
    
    override func fire() { }
    
    override func invalidate() {
        MockTimer.messages.append(.invalidate)
    }
}
