//
//  GoClockExTests.swift
//  GoClockTests
//
//  Created by zky on 2022/11/13.
//

import XCTest
@testable import GoClock

final class GoClockExTests: XCTestCase {
    
    override func setUp() {
        XTimer.currentTimer = nil
        XTimer.messages.removeAll()
    }
    
    func test_actionsAlterStatesCorrectly() {
        let sut = makeSUT()
        
        // Ready state on create
        XCTAssertEqual(sut.state, .ready)
        XCTAssertEqual(sut.hostRemainingTime, GoClockEx.RemainingTime(timeSetting: defaultTimeSetting()))
        XCTAssertEqual(sut.guestRemainingTime, GoClockEx.RemainingTime(timeSetting: defaultTimeSetting()))
        
        // Only start can work on ready state
        XCTAssertFalse(sut.switchSide())
        XCTAssertFalse(sut.pause())
        XCTAssertFalse(sut.resume())
        XCTAssertFalse(sut.reset())
        
        // Start alters state to running at host
        XCTAssertTrue(sut.start())
        XCTAssertFalse(sut.start())
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
    
    func test_actionsScheduleAndInvalidateTimerCorrectly() {
        let sut = makeSUT()
        XCTAssertNil(XTimer.currentTimer)
        
        sut.start()
        XCTAssertNotNil(XTimer.currentTimer)
        XCTAssertEqual(XTimer.messages, [.schedule])
        
        sut.switchSide()
        XCTAssertEqual(XTimer.messages, [.schedule, .invalidate, .schedule])
        
        sut.pause()
        XCTAssertEqual(XTimer.messages, [.schedule, .invalidate, .schedule, .invalidate])
        
        sut.resume()
        XCTAssertEqual(XTimer.messages, [.schedule, .invalidate, .schedule, .invalidate, .schedule])
        
        sut.pause()
        XCTAssertEqual(XTimer.messages, [.schedule, .invalidate, .schedule, .invalidate, .schedule, .invalidate])
        sut.reset()
        XCTAssertEqual(XTimer.messages, [.schedule, .invalidate, .schedule, .invalidate, .schedule, .invalidate])
    }
    
    func test_timerTickingInRunningState_updateRemainingTimeAndCallsUpdatedBlock() {
        let sut = makeSUT(interval: 0.5)
        
        var updatedCount = 0
        sut.setUpdatedBlock {
            updatedCount += 1
        }
        
        sut.start()
        XCTAssertEqual(updatedCount, 1)
        
        XTimer.tick()
        XCTAssertEqual(updatedCount, 1)
        
        XTimer.tick()
        XCTAssertEqual(updatedCount, 2)
        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 299)
        
        sut.pause()
        XCTAssertEqual(updatedCount, 3)
        
        sut.resume()
        XCTAssertEqual(updatedCount, 4)
        
        sut.switchSide()
        XCTAssertEqual(updatedCount, 5)
        
        XTimer.tick()
        XTimer.tick()
        XCTAssertEqual(updatedCount, 6)
        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 299)
        XCTAssertEqual(sut.guestRemainingTime.currentSeconds, 299)
        
        sut.pause()
        sut.resume()
        
        XCTAssertEqual(updatedCount, 8)
        XTimer.tick()
        XTimer.tick()
        XCTAssertEqual(updatedCount, 9)
    }
    
    func test_hostRemainingSecondsCountToZeroAndAnotherSecond_updateRemainingTimeToNextCountDownPhaseAndCallsUpdatedBlock() {
        let sut = makeSUT(interval: 0.5, timeSetting: TimeSetting(freeTimeSeconds: 1, countDownSeconds: 1, countDownTimes: 2))
        
        var updatedCount = 0
        sut.setUpdatedBlock {
            updatedCount += 1
        }
        
        sut.start()
        XTimer.tick()
        XTimer.tick()
        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 0)
        XCTAssertEqual(sut.hostRemainingTime.stillFree, true)
        
        XTimer.tick()
        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 0)
        XCTAssertEqual(sut.hostRemainingTime.stillFree, true)
        
        XTimer.tick()
        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 1)
        XCTAssertEqual(sut.hostRemainingTime.stillFree, false)
        
        XTimer.tick()
        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 1)
        XCTAssertEqual(sut.hostRemainingTime.remainingCountDownTimes, 2)
        
        XTimer.tick()
        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 0)
        XCTAssertEqual(sut.hostRemainingTime.remainingCountDownTimes, 2)
        
        XTimer.tick()
        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 0)
        XCTAssertEqual(sut.hostRemainingTime.remainingCountDownTimes, 2)
        
        XTimer.tick()
        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 1)
        XCTAssertEqual(sut.hostRemainingTime.remainingCountDownTimes, 1)
    }
    
    func test_guestRemainingSecondsCountToZeroAndAnotherSecond_updateRemainingTimeToNextCountDownPhaseAndCallsUpdatedBlock() {
        let sut = makeSUT(interval: 0.5, timeSetting: TimeSetting(freeTimeSeconds: 1, countDownSeconds: 1, countDownTimes: 2))
        
        var updatedCount = 0
        sut.setUpdatedBlock {
            updatedCount += 1
        }
        
        sut.start()
        sut.switchSide()
        XTimer.tick()
        XTimer.tick()
        XCTAssertEqual(sut.guestRemainingTime.currentSeconds, 0)
        XCTAssertEqual(sut.guestRemainingTime.stillFree, true)
        
        XTimer.tick()
        XCTAssertEqual(sut.guestRemainingTime.currentSeconds, 0)
        XCTAssertEqual(sut.guestRemainingTime.stillFree, true)
        
        XTimer.tick()
        XCTAssertEqual(sut.guestRemainingTime.currentSeconds, 1)
        XCTAssertEqual(sut.guestRemainingTime.stillFree, false)
        
        XTimer.tick()
        XCTAssertEqual(sut.guestRemainingTime.currentSeconds, 1)
        XCTAssertEqual(sut.guestRemainingTime.remainingCountDownTimes, 2)
        
        XTimer.tick()
        XCTAssertEqual(sut.guestRemainingTime.currentSeconds, 0)
        XCTAssertEqual(sut.guestRemainingTime.remainingCountDownTimes, 2)
        
        XTimer.tick()
        XCTAssertEqual(sut.guestRemainingTime.currentSeconds, 0)
        XCTAssertEqual(sut.guestRemainingTime.remainingCountDownTimes, 2)
        
        XTimer.tick()
        XCTAssertEqual(sut.guestRemainingTime.currentSeconds, 1)
        XCTAssertEqual(sut.guestRemainingTime.remainingCountDownTimes, 1)
    }
    
    func test_hostRemainingCountDownTimesCountToZero_becomesTimedOutStateAndCallsUpdatedBlock() {
        
        let sut = makeSUT(interval: 1.0, timeSetting: TimeSetting(freeTimeSeconds: 1, countDownSeconds: 1, countDownTimes: 1))
        
        var updatedCount = 0
        sut.setUpdatedBlock {
            updatedCount += 1
        }
        sut.start()
        
        XTimer.tick()
        XTimer.tick()
        XTimer.tick()
        
        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 0)
        XCTAssertEqual(sut.hostRemainingTime.remainingCountDownTimes, 1)
        
        XTimer.tick()
        XCTAssertEqual(sut.state, .timedOut)
    }
    
    func test_guestRemainingCountDownTimesCountToZero_becomesTimedOutStateAndCallsUpdatedBlock() {
        
        let sut = makeSUT(interval: 1.0, timeSetting: TimeSetting(freeTimeSeconds: 1, countDownSeconds: 1, countDownTimes: 1))
        
        var updatedCount = 0
        sut.setUpdatedBlock {
            updatedCount += 1
        }
        sut.start()
        sut.switchSide()
        
        XTimer.tick()
        XTimer.tick()
        XTimer.tick()
        
        XCTAssertEqual(sut.guestRemainingTime.currentSeconds, 0)
        XCTAssertEqual(sut.guestRemainingTime.remainingCountDownTimes, 1)
        
        XTimer.tick()
        XCTAssertEqual(sut.state, .timedOut)
    }
    
    // MARK: -- Helpers
    
    private func makeSUT(interval: TimeInterval = DefaultInterval, timeSetting: TimeSetting = defaultTimeSetting()) -> GoClockEx {
        let sut = GoClockEx(timeSetting: timeSetting, interval: interval, timeProvider: XTimer.self)
        
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private class XTimer: Timer {
        
        enum Message {
            case schedule
            case invalidate
        }
        
        static var currentTimer: XTimer?
        static var messages = [Message]()
        static var block: ((Timer) -> Void)?
        
        override class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
            
            let timer = XTimer()
            currentTimer = timer
            self.block = block
            messages.append(.schedule)
            return timer
        }
        
        override func invalidate() {
            XTimer.currentTimer = nil
            XTimer.messages.append(.invalidate)
        }
        
        static func tick() {
            block!(currentTimer!)
        }
    }
}

private func defaultTimeSetting() -> TimeSetting {
    TimeSetting(freeTimeSeconds: 300, countDownSeconds: 30, countDownTimes: 3)
}
