//
//  MockGoClock.swift
//  GoClockAppTests
//
//  Created by zky on 2022/11/14.
//

import Foundation
@testable import GoClock

class MockGoClock: GoClock {
    enum Message {
    case start, switchSide, pause, resume
    }
    
    var messages = [Message]()
    
    override func start() -> Bool {
        messages.append(.start)
        return super.start()
    }
    
    override func switchSide() -> Bool {
        messages.append(.switchSide)
        return super.switchSide()
    }
    
    override func pause() -> Bool {
        messages.append(.pause)
        return super.pause()
    }
    
    override func resume() -> Bool {
        messages.append(.resume)
        return super.resume()
    }
}
