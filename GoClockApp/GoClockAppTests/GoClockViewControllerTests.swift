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
        clock.setUpdatedClosure { [weak self] in
            self?.setUpView()
        }
    }
    
    var hostSideView: SideView!
    var guestSideView: SideView!
    
    override func viewDidLoad() {
        setUpView()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        hostSideView.addGestureRecognizer(tapRecognizer)
        guestSideView.addGestureRecognizer(tapRecognizer)
    }
    
    func setUpView() {
        guard let clock = clock else { return }
        hostSideView = SideView(remainingSeconds: clock.sides[0].remainingSeconds)
        guestSideView = SideView(remainingSeconds: clock.sides[1].remainingSeconds)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let sender = sender, let clock = clock else { return }
        guard clock.sides.filter({ $0.remainingSeconds == 0 }).isEmpty else {
            return
        }
        if sender.view == hostSideView {
            guard clock.currentRunningIndex == 0 else { return }
        } else {
            guard clock.currentRunningIndex == 1 else { return }
        }
        clock.switchSide()
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
    
    func test_tapsRunningSideView_callsSwitchSideOnClock() {
        let (sut, clock) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.tapGuestSideView()
        XCTAssertEqual(clock.switchSideCount, 1)
        
        sut.tapHostSideView()
        XCTAssertEqual(clock.switchSideCount, 2)
    }
    
    func test_tapsNotRunningSideView_doesNotCallSwitchSideOnClock() {
        let (sut, clock) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.tapHostSideView()
        XCTAssertEqual(clock.switchSideCount, 0)
        
        sut.tapGuestSideView()
        XCTAssertEqual(clock.switchSideCount, 1)
        
        sut.tapGuestSideView()
        XCTAssertEqual(clock.switchSideCount, 1)
    }
    
    func test_clockRunning_clockUpdatedWhenSecondsPasses() {
        let (sut, clock) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.tapGuestSideView()
        clock.callsUpdated()
        
        XCTAssertEqual(sut.hostTime, 1)
        
        sut.tapHostSideView()
        clock.callsUpdated()
        
        XCTAssertEqual(sut.guestTime, 1)
    }
    
    func test_tapsSideView_doesNotCallSwitchSideOnClock_whenOneSideRemainingTimeIsZero() {
        let (sut, clock) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.tapGuestSideView()
        clock.callsUpdated()
        clock.callsUpdated()
        
        XCTAssertEqual(sut.hostTime, 0)
        
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
            super.switchSide()
        }
        
        func callsUpdated() {
            (sides[currentRunningIndex] as! MockSide).callsUpdated()
            updated?()
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
    
    func tapGuestSideView() {
        guestSideView.gestureRecognizers?.removeAll()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        guestSideView.addGestureRecognizer(tapRecognizer)
        handleTap(tapRecognizer)
    }
}
