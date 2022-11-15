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
        
        XCTAssertEqual(sut.hostTime, 3)
        XCTAssertEqual(sut.guestTime, 3)
    }
    
    func test_tapsSideView_callsStartAndSwitchSideOnClockIfTapOnRightSide() {
        let (sut, clock) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.tapGuestSideView()
        XCTAssertEqual(clock.messages, [.start])
        
        sut.tapHostSideView()
        XCTAssertEqual(clock.messages, [.start, .switchSide])
        
        sut.tapHostSideView()
        XCTAssertEqual(clock.messages, [.start, .switchSide])
        
        sut.tapGuestSideView()
        XCTAssertEqual(clock.messages, [.start, .switchSide, .switchSide])
    }
    
    func test_clockRunning_clockUpdatedWhenSecondsPasses() {
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.tapGuestSideView()
        
        XTimer.tick()
        XCTAssertEqual(sut.hostTime, 3)
        
        XTimer.tick()
        XCTAssertEqual(sut.hostTime, 2)
        
        sut.tapHostSideView()
        
        XTimer.tick()
        XCTAssertEqual(sut.guestTime, 3)
        
        XTimer.tick()
        XCTAssertEqual(sut.guestTime, 2)
    }
    
    // MARK: -- Helpers
    
    private func makeSUT(interval: TimeInterval = 0.5) -> (sut: GoClockViewController, clock: MockGoClockEx) {
        let clock = MockGoClockEx(timeSetting: TimeSetting(freeTimeSeconds: 3, countDownSeconds: 3, countDownTimes: 3), interval: interval, timeProvider: XTimer.self)
        
        let sut = GoClockViewController(clock: clock)
        
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
