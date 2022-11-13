///
/// Created by Zheng Kanyan on 2022/10/27.
/// 
///

import XCTest
@testable import GoClock

final class ConcreteSideTests: XCTestCase {
    
    override func setUp() {
        MockTimer.currentTimers.removeAll()
    }

    func test_doesNotFireTimerOnCreate() {
        let (_, timer) = makeSUT()
        
        XCTAssertEqual(timer.messages, [])
    }
    
    func test_start_firesTimer() {
        let (sut, timer) = makeSUT()
        
        sut.start()
        
        XCTAssertEqual(timer.messages, [.fire])
    }
    
    func test_stop_invalidatesTimer() {
        let (sut, timer) = makeSUT()
        
        sut.stop()
        
        XCTAssertEqual(timer.messages, [.invalidate])
    }
    
    func test_start_callsUpdatedBlockWhenTimePassedOneSecond() {
        let (sut, _) = makeSUT(interval: 1.0)
        
        XCTAssertEqual(sut.remainingTime.freeTimeSeconds, 2)
        
        sut.setUpdatedClosure { [weak sut] in
            XCTAssertEqual(sut?.remainingTime.freeTimeSeconds, 1)
        }
        
        sut.start()
        MockTimer.tick()
    }
    
    func test_start_doesNotCallUpdatedBlockWhenTimeHasNotPassedOneSecond() {
        let (sut, _) = makeSUT(interval: 0.5)
        
        var updatedCount = 0
        sut.setUpdatedClosure { updatedCount += 1 }
        
        sut.start()
        MockTimer.tick()
        
        XCTAssertEqual(updatedCount, 0)
    }
    
    func test_start_callsInvalidWhenTimeGoingToZero() {
        let (sut, timer) = makeSUT(interval: 0.5)
        
        var updatedCount = 0
        sut.setUpdatedClosure { updatedCount += 1 }
        
        sut.start()
        MockTimer.tick()
        MockTimer.tick()
        MockTimer.tick()
        MockTimer.tick()
        
        XCTAssertEqual(updatedCount, 2)
        XCTAssertEqual(timer.messages, [.fire, .invalidate])
    }
    
    func test_start_doesNotCallFireOnTimerWhenRemainingTimeIsZero() {
        let (sut, timer) = makeSUT(interval: 1.0)
        
        var updatedCount = 0
        sut.setUpdatedClosure { updatedCount += 1 }
        
        sut.start()
        MockTimer.tick()
        MockTimer.tick()
        sut.start()
        
        XCTAssertEqual(updatedCount, 2)
        XCTAssertEqual(timer.messages, [.fire, .invalidate])
    }
    
    func test_start_callsFireOnTimerWhenRemainingSecondsIsZeroButRemainingTimeStillMoreThanHalfDefaultInterval() {
        let (sut, timer) = makeSUT(interval: 0.3)
        
        var updatedCount = 0
        sut.setUpdatedClosure { updatedCount += 1 }
        
        sut.start()
        MockTimer.tick()
        MockTimer.tick()
        MockTimer.tick()
        sut.stop()
        sut.start()
        
        XCTAssertEqual(updatedCount, 0)
        XCTAssertEqual(timer.messages, [.fire, .invalidate, .fire])
    }
    
    // MARK: -- Helpers
    
    private func makeSUT(interval: TimeInterval = DefaultInterval,
                         file: StaticString = #filePath, line: UInt = #line) -> (sut: ConcreteSide, timer: TimerSpy) {
    
        let timer = TimerSpy(interval: interval, timeProvider: MockTimer.self)
        let sut = ConcreteSide(timeSetting: TimeSetting(freeTimeSeconds: 2, countDownSeconds: 2, countDownTimes: 2), timer: timer)
        
        trackForMemoryLeaks(timer, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, timer)
    }
    
    private class TimerSpy: GoTimer {
        enum Message {
            case fire, invalidate
        }
        
        var messages = [Message]()
        
        override func fire() {
            messages.append(.fire)
            super.fire()
        }
        
        override func invalidate() {
            messages.append(.invalidate)
            super.invalidate()
        }
    }
}
