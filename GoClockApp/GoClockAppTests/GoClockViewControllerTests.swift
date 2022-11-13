///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import XCTest
@testable import GoClockApp
@testable import GoClock

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
        let side0 = MockSide(timeSetting: TimeSetting(freeTimeSeconds: 2, countDownSeconds: 2, countDownTimes: 2))
        let side1 = MockSide(timeSetting: TimeSetting(freeTimeSeconds: 2, countDownSeconds: 2, countDownTimes: 2))
        let clock = MockGoClock(sides: [side0, side1])
        let sut = GoClockViewController(clock: clock)
        
        trackForMemoryLeaks(side0)
        trackForMemoryLeaks(side1)
        trackForMemoryLeaks(clock)
        trackForMemoryLeaks(sut)
        
        return (sut, clock)
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
