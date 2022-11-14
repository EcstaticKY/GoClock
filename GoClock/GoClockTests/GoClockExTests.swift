//
//  GoClockExTests.swift
//  GoClockTests
//
//  Created by zky on 2022/11/13.
//

import XCTest
@testable import GoClock

public class GoClockEx {
    public enum State: Equatable {
        case ready, running(atHost: Bool), pausing(atHost: Bool), timedOut
    }
    
    public enum RemainingTime: Equatable {
        case free(seconds: UInt)
        case countDown(seconds: UInt, times: UInt)
    }
    
    public private(set) var state = State.ready
    public var hostRemainingTime: RemainingTime
    public var guestRemainingTime: RemainingTime
    
    private let timeSetting: TimeSetting
    
    public init(timeSetting: TimeSetting) {
        self.timeSetting = timeSetting
        hostRemainingTime = .free(seconds: timeSetting.freeTimeSeconds)
        guestRemainingTime = .free(seconds: timeSetting.freeTimeSeconds)
    }
    
    @discardableResult
    public func start() -> Bool {
        state = .running(atHost: true)
        return true
    }
    
    @discardableResult
    public func switchSide() -> Bool {
        guard case .running(let atHost) = state else {
            return false
        }
        
        state = .running(atHost: !atHost)
        return true
    }
    
    @discardableResult
    public func pause() -> Bool {
        guard case .running(let atHost) = state else {
            return false
        }
        
        state = .pausing(atHost: atHost)
        return true
    }
    
    @discardableResult
    public func resume() -> Bool {
        guard case .pausing(let atHost) = state else {
            return false
        }
        
        state = .running(atHost: atHost)
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
}

final class GoClockExTests: XCTestCase {
    
    func test_actionsAlterStatesCorrectly() {
        let sut = makeSUT()
        
        // Ready state on create
        XCTAssertEqual(sut.state, .ready)
        XCTAssertEqual(sut.hostRemainingTime, .free(seconds: 300))
        XCTAssertEqual(sut.guestRemainingTime, .free(seconds: 300))
        
        // Only start can work on ready state
        XCTAssertFalse(sut.switchSide())
        XCTAssertFalse(sut.pause())
        XCTAssertFalse(sut.resume())
        XCTAssertFalse(sut.reset())
        
        // Start alters state to running at host
        XCTAssertTrue(sut.start())
        XCTAssertEqual(sut.state, .running(atHost: true))
        
        // Switch side toggles if running state at host side
        XCTAssertTrue(sut.switchSide())
        XCTAssertEqual(sut.state, .running(atHost: false))
        XCTAssertTrue(sut.switchSide())
        XCTAssertEqual(sut.state, .running(atHost: true))
        XCTAssertTrue(sut.switchSide())
        XCTAssertEqual(sut.state, .running(atHost: false))
        
        // Pause alters state to pausing
        XCTAssertTrue(sut.pause())
        XCTAssertEqual(sut.state, .pausing(atHost: false))
        XCTAssertFalse(sut.switchSide())
        
        // Resume alters state back to running at side before pausing
        XCTAssertTrue(sut.resume())
        XCTAssertEqual(sut.state, .running(atHost: false))
        
        // Reset works only on pausing state and alters state to ready
        XCTAssertFalse(sut.reset())
        sut.pause()
        XCTAssertTrue(sut.reset())
        XCTAssertEqual(sut.state, .ready)
    }
    
    // MARK: -- Helpers
    
    private func makeSUT() -> GoClockEx {
        let timeSetting = TimeSetting(freeTimeSeconds: 300, countDownSeconds: 30, countDownTimes: 3)
        let sut = GoClockEx(timeSetting: timeSetting)
        
        trackForMemoryLeaks(sut)
        return sut
    }
}
