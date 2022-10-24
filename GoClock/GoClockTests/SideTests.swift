///
/// Created by Zheng Kanyan on 2022/10/24.
/// 
///

import XCTest
import GoClock

final class SideTests: XCTestCase {

    func test_doesNotCallUpdatedBlockOnCreate() throws {
        let _ = Side(remainingSeconds: 1) {
            XCTFail("Expected not calling updated block")
        }
    }
}
