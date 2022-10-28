///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import XCTest
@testable import GoClockApp
@testable import GoClock

final class GoClockViewController: UIViewController {
    private var clock: GoClock?
    
    convenience init(clock: GoClock) {
        self.init()
        self.clock = clock
    }
    
    var hostSideView: SideView!
    var guestSideView: SideView!
    
    override func viewDidLoad() {
        guard let clock = clock else { return }
        hostSideView = SideView(remainingSeconds: clock.sides[0].remainingSeconds)
        guestSideView = SideView(remainingSeconds: clock.sides[1].remainingSeconds)
    }
}

final class SideView: UIView {
    var timeLabel: UILabel!
    
    convenience init(remainingSeconds: UInt) {
        self.init()
        timeLabel = UILabel()
        timeLabel.text = "\(remainingSeconds)"
    }
}

final class GoClockViewControllerTests: XCTestCase {

    func test_showsClockTimeOnDisplay() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.hostTime, 2)
        XCTAssertEqual(sut.guestTime, 2)
    }
    
    // MARK: -- Helpers
    
    private func makeSUT() -> GoClockViewController {
        let side0 = MockSide(remainingSeconds: 2)
        let side1 = MockSide(remainingSeconds: 2)
        let clock = MockGoClock(sides: [side0, side1])
        let sut = GoClockViewController(clock: clock)
        
        trackForMemoryLeaks(side0)
        trackForMemoryLeaks(side1)
        trackForMemoryLeaks(clock)
        trackForMemoryLeaks(sut)
        
        return sut
    }
    
    private class MockGoClock: GoClock {
        
    }
}

extension GoClockViewController {
    var hostTime: UInt {
        UInt(hostSideView.timeLabel.text!)!
    }
    
    var guestTime: UInt {
        UInt(guestSideView.timeLabel.text!)!
    }
}
