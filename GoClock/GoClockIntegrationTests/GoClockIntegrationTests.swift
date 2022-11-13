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
        exp.expectedFulfillmentCount = 6
        sut.setUpdatedClosure {
            exp.fulfill()
        }

        sut.switchSide()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.1) {
            DispatchQueue.main.async {
                sut.switchSide()
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.1) {
                    DispatchQueue.main.async {
                        sut.switchSide()
                    }
                }
            }
        }
        
        wait(for: [exp], timeout: 3.3)

        XCTAssertEqual((sut.sides[0] as! ConcreteSide).remainingTime.freeTimeSeconds, 28)
        XCTAssertEqual((sut.sides[1] as! ConcreteSide).remainingTime.freeTimeSeconds, 29)
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> GoClock {

        let side0 = ConcreteSide(timeSetting: TimeSetting(freeTimeSeconds: DefaultTotalSeconds, countDownSeconds: 2, countDownTimes: 2), timer: GoTimer())
        let side1 = ConcreteSide(timeSetting: TimeSetting(freeTimeSeconds: DefaultTotalSeconds, countDownSeconds: 2, countDownTimes: 2), timer: GoTimer())
        let sut = GoClock(sides: [side0, side1])

        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(side0)
        trackForMemoryLeaks(side1)

        return sut
    }
}
