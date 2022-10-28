///
/// Created by Zheng Kanyan on 2022/10/24.
///
///

import XCTest
@testable import GoClock

final class GoTimerTests: XCTestCase {
    
    override func setUp() {
        MockTimer.currentTimers.removeAll()
    }

    func test_fire_shouldCallTimeUpdatedBlockWhenTimerTicking() {
        
        let (sut, timeUpdatedSpy) = makeSUT()
        
        sut.fire()
        MockTimer.tick()
        MockTimer.tick()

        XCTAssertEqual(timeUpdatedSpy.updatedIntervals, [DefaultInterval, DefaultInterval])
    }
    
    func test_fireAndInvalidate_callsRealTimerCorrectMethods() {

        let (sut, _) = makeSUT()

        sut.fire()
        XCTAssertEqual(MockTimer.currentTimers[0].messages, [.fire])

        sut.invalidate()
        XCTAssertEqual(MockTimer.currentTimers[0].messages, [.fire, .invalidate])
    }

    func test_twoTimers_wouldNotInterfereEachOther() {
        let (sut0, _) = makeSUT()
        sut0.fire()
        let (sut1, _) = makeSUT()
        sut1.fire()

        XCTAssertEqual(MockTimer.currentTimers[0].messages, [.fire])
        XCTAssertEqual(MockTimer.currentTimers[1].messages, [.fire])

        sut1.invalidate()
        XCTAssertEqual(MockTimer.currentTimers[1].messages, [.fire, .invalidate])
        XCTAssertEqual(MockTimer.currentTimers[0].messages, [.fire])

        sut0.invalidate()
        XCTAssertEqual(MockTimer.currentTimers[0].messages, [.fire, .invalidate])
        XCTAssertEqual(MockTimer.currentTimers[1].messages, [.fire, .invalidate])
    }

    func test_twoTimers_shouldCallCorrectTimeUpdatedBlockWhenTimerTicking() {
        
        let (sut1, timeUpdatedSpy1) = makeSUT()
        let (sut0, timeUpdatedSpy0) = makeSUT()

        sut0.fire()
        sut1.fire()
        MockTimer.tick(at: 1)
        MockTimer.tick(at: 1)

        XCTAssertEqual(timeUpdatedSpy0.updatedIntervals, [])
        XCTAssertEqual(timeUpdatedSpy1.updatedIntervals, [DefaultInterval, DefaultInterval])
    }
    
    // MARK: -- Helpers
    
    private func makeSUT() -> (sut: GoTimer, timeUpdatedSpy: TimeUpdatedSpy) {
        let timeUpdatedSpy = TimeUpdatedSpy()
        let sut = GoTimer(timeProvider: MockTimer.self)
        sut.setTickedClosure(timeUpdatedSpy.timeUpdated)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(timeUpdatedSpy)
        
        return (sut, timeUpdatedSpy)
    }
                               
    private class TimeUpdatedSpy {
        var updatedIntervals = [TimeInterval]()
        
        func timeUpdated(interval: TimeInterval) {
            updatedIntervals.append(interval)
        }
    }
}
