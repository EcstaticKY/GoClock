///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import Foundation
import GoClock

class MockSide: Side {
    enum Message {
    case start, stop
    }
    
    var remainingSeconds: UInt
    var messages = [Message]()
    var updated: (() -> Void)?
    
    init(remainingSeconds: UInt) {
        self.remainingSeconds = remainingSeconds
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
        remainingSeconds -= 1
        updated?()
    }
}
