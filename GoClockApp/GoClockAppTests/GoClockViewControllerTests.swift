///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import XCTest
@testable import GoClockApp
@testable import GoClock

final class GoClockViewController: UIViewController {
    
}

final class GoClockViewControllerTests: XCTestCase {

    func test_showsClockTimeOnDisplay() throws {
        let _ = makeSUT()
    }
    
    // MARK: -- Helpers
    
    private func makeSUT() -> GoClockViewController {
        GoClockViewController()
    }
    
    private class MockGoClock: GoClock {
        
    }
}
