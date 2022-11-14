//
//  GoClockExTests.swift
//  GoClockTests
//
//  Created by zky on 2022/11/13.
//

import XCTest
@testable import GoClock

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
    
    func test_startOrSwitchSideOrResume_schedulesANewTimer() {
        let sut = makeSUT()
        
        sut.start()
    }
    
    // MARK: -- Helpers
    
    private func makeSUT() -> GoClockEx {
        let timeSetting = TimeSetting(freeTimeSeconds: 300, countDownSeconds: 30, countDownTimes: 3)
        let sut = GoClockEx(timeSetting: timeSetting)
        
        trackForMemoryLeaks(sut)
        return sut
    }
}
