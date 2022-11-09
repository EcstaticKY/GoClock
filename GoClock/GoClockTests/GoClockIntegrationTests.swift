///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import XCTest
@testable import GoClock

final class GoClockIntegrationTests: XCTestCase {
    
    func test_GoClockInstanceCallsUpdatedWhenTimerTickingOneSecond() {
        let sut = makeSUT()

        let exp = expectation(description: "Wait for clock updated")
        exp.expectedFulfillmentCount = 2
        sut.setUpdatedClosure {
            exp.fulfill()
        }

        sut.switchSide()
        wait(for: [exp], timeout: 1.1)

        XCTAssertEqual((sut.sides[0] as! ConcreteSide).remainingSeconds, 29)
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> GoClock {

        let side0 = ConcreteSide(totalSeconds: DefaultTotalSeconds, timer: GoTimer())
        let side1 = ConcreteSide(totalSeconds: DefaultTotalSeconds, timer: GoTimer())
        let sut = GoClock(sides: [side0, side1])

        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(side0)
        trackForMemoryLeaks(side1)

        return sut
    }
}
