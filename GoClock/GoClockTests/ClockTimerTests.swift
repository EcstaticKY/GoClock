///
/// Created by Zheng Kanyan on 2022/10/24.
/// 
///

import XCTest
import GoClock

class ClockTimerTests: XCTestCase {
    func test_timer() {
        
        let exp = expectation(description: "Wait for time update")
        exp.expectedFulfillmentCount = 10
        
        let sut = ClockTimer {
            exp.fulfill()
        }
        sut.fire()
        
        wait(for: [exp], timeout: 1.0)
    }
}
