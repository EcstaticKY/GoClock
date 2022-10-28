///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import XCTest
@testable import GoClock

let DefaultTotalSeconds: UInt = 30

final class GoClockTests: XCTestCase {
    func test_createsTwoSidesCorrectlyOnCreate() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.sides.count, 2)
        XCTAssertEqual(sut.sides[0].remainingSeconds, DefaultTotalSeconds)
        XCTAssertEqual(sut.sides[1].remainingSeconds, DefaultTotalSeconds)
    }
    
    func test_switchSide_switchCurrentWaitingIndexFromZeroToOne() {
        let sut = makeSUT()
        XCTAssertEqual(sut.currentWaitingIndex, 0)
        
        sut.switchSide()
        XCTAssertEqual(sut.currentWaitingIndex, 1)
        
        sut.switchSide()
        XCTAssertEqual(sut.currentWaitingIndex, 0)
    }
    
    func test_switchSide_callsStartOnCurrentWaitingSideAndCallsStopOnAnotherSide() {
        let sut = makeSUT()
        
        sut.switchSide()
        XCTAssertEqual((sut.sides[0] as! MockSide).messages, [.start])
        XCTAssertEqual((sut.sides[1] as! MockSide).messages, [.stop])
        
        sut.switchSide()
        XCTAssertEqual((sut.sides[0] as! MockSide).messages, [.start, .stop])
        XCTAssertEqual((sut.sides[1] as! MockSide).messages, [.stop, .start])
    }
    
    func test_switchSide_callsUpdatedBlockWhenSideFoundItsRemainingSecondsUpdated() {
        
        var updatedCount = 0
        let sut = makeSUT {
            updatedCount += 1
        }
        
        sut.switchSide()
        (sut.sides[0] as! MockSide).callsUpdated()
        (sut.sides[1] as! MockSide).callsUpdated()
        
        sut.switchSide()
        (sut.sides[1] as! MockSide).callsUpdated()
        (sut.sides[0] as! MockSide).callsUpdated()
        
        XCTAssertEqual(updatedCount, 2)
    }
    
    // MARK: -- Helpers
    
    private func makeSUT(clockUpdated: @escaping () -> Void = { },
                         file: StaticString = #filePath, line: UInt = #line) -> GoClock {
        let sut = GoClock(sides: [MockSide(remainingSeconds: DefaultTotalSeconds), MockSide(remainingSeconds: DefaultTotalSeconds)])
        sut.setUpdatedClosure(clockUpdated)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private class MockSide: Side {
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
}
