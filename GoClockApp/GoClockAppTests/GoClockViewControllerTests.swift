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
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        hostSideView.addGestureRecognizer(tapRecognizer)
        guestSideView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let sender = sender else { return }
        if sender.view == hostSideView {
            guard
        }
        clock?.switchSide()
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
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.hostTime, 2)
        XCTAssertEqual(sut.guestTime, 2)
    }
    
    func test_tapsWaitingSideView_callsSwitchSideOnClock() {
        let (sut, clock) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.tapHostSideView()
        XCTAssertEqual(clock.switchSideCount, 1)
        
        sut.tapHostSideView()
        XCTAssertEqual(clock.switchSideCount, 1)
    }
    
    // MARK: -- Helpers
    
    private func makeSUT() -> (sut: GoClockViewController, clock: MockGoClock) {
        let side0 = MockSide(remainingSeconds: 2)
        let side1 = MockSide(remainingSeconds: 2)
        let clock = MockGoClock(sides: [side0, side1])
        let sut = GoClockViewController(clock: clock)
        
        trackForMemoryLeaks(side0)
        trackForMemoryLeaks(side1)
        trackForMemoryLeaks(clock)
        trackForMemoryLeaks(sut)
        
        return (sut, clock)
    }
    
    private class MockGoClock: GoClock {
        var switchSideCount = 0
        
        override func switchSide() {
            switchSideCount += 1
        }
    }
}

extension GoClockViewController {
    var hostTime: UInt {
        UInt(hostSideView.timeLabel.text!)!
    }
    
    var guestTime: UInt {
        UInt(guestSideView.timeLabel.text!)!
    }
    
    func tapHostSideView() {
        hostSideView.gestureRecognizers?.removeAll()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        hostSideView.addGestureRecognizer(tapRecognizer)
        handleTap(tapRecognizer)
    }
}
