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
    
    func test_switchSide_switchCurrentTappingIndexFromOneToZero() {
        let sut = makeSUT()
        XCTAssertEqual(sut.currentRunningIndex, 1)
        
        sut.switchSide()
        XCTAssertEqual(sut.currentRunningIndex, 0)
        
        sut.switchSide()
        XCTAssertEqual(sut.currentRunningIndex, 1)
        
        sut.switchSide()
        XCTAssertEqual(sut.currentRunningIndex, 0)
    }
    
    func test_switchSide_callsStopOnCurrentTappingSideAndCallsStartOnAnotherSide() {
        let sut = makeSUT()
        
        sut.switchSide()
        XCTAssertEqual((sut.sides[0] as! MockSide).messages, [.start])
        XCTAssertEqual((sut.sides[1] as! MockSide).messages, [.stop])
        
        sut.switchSide()
        XCTAssertEqual((sut.sides[0] as! MockSide).messages, [.start, .stop])
        XCTAssertEqual((sut.sides[1] as! MockSide).messages, [.stop, .start])
        
        sut.switchSide()
        XCTAssertEqual((sut.sides[0] as! MockSide).messages, [.start, .stop, .start])
        XCTAssertEqual((sut.sides[1] as! MockSide).messages, [.stop, .start, .stop])
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
        
        XCTAssertEqual(updatedCount, 4)
    }
    
    // MARK: -- Helpers
    
    private func makeSUT(clockUpdated: @escaping () -> Void = { },
                         file: StaticString = #filePath, line: UInt = #line) -> GoClock {
        let sut = GoClock(sides: [MockSide(remainingSeconds: DefaultTotalSeconds), MockSide(remainingSeconds: DefaultTotalSeconds)])
        sut.setUpdatedClosure(clockUpdated)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
