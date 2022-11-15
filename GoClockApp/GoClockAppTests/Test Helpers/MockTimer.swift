///
/// Created by Zheng Kanyan on 2022/11/14.
///
///

import Foundation

class MockTimer: Timer {
    
    enum Message {
        case schedule
        case invalidate
    }
    
    static var currentTimer: MockTimer?
    static var messages = [Message]()
    static var block: ((Timer) -> Void)?
    
    override class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        
        let timer = MockTimer()
        currentTimer = timer
        self.block = block
        messages.append(.schedule)
        return timer
    }
    
    override func invalidate() {
        MockTimer.currentTimer = nil
        MockTimer.messages.append(.invalidate)
    }
    
    static func tick() {
        block!(currentTimer!)
    }
}
