///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import XCTest
import GoClock

final class GoClockIntegrationTests: XCTestCase {
    
    func test_GoClockInstanceCallsUpdatedWhenTimerTickingOneSecond() {
        let sut = makeSUTex()

        let exp = expectation(description: "Wait for clock updated")
        exp.expectedFulfillmentCount = 7
        sut.setUpdatedBlock {
            exp.fulfill()
        }

        sut.start()
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

        XCTAssertEqual(sut.hostRemainingTime.currentSeconds, 9)
        XCTAssertEqual(sut.guestRemainingTime.currentSeconds, 8)
    }
    
    private func makeSUTex(file: StaticString = #filePath, line: UInt = #line) -> GoClock {

        let timeSetting = TimeSetting(freeTimeSeconds: 10, countDownSeconds: 10, countDownTimes: 2)
        let sut = GoClock(timeSetting: timeSetting)

        trackForMemoryLeaks(sut)
        
        return sut
    }
}
