///
/// Created by Zheng Kanyan on 2022/10/31.
///
///

import XCTest
import GoClock
@testable import GoClockApp

let DefaultTotalSeconds: UInt = 30

final class GoClockSnapshotTests: XCTestCase {

    func test_defaultClock() throws {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        assert(snapshot: sut.snapshot(), named: "DEFAULT_CLOCK")
    }
    
    func test_clockWithHostSideRunning() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.tapGuestSideView()
        
        assert(snapshot: sut.snapshot(), named: "HOST_SIDE_RUNNING")
    }
    
    func test_clockWithGuestSideRunning() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.tapGuestSideView()
        sut.tapHostSideView()
        
        assert(snapshot: sut.snapshot(), named: "GUEST_SIDE_RUNNING")
    }

    // MARK: -- Helpers

    private func makeSUT(interval: TimeInterval = 0.5) -> (sut: GoClockViewController, clock: MockGoClock) {
        let clock = MockGoClock(timeSetting: TimeSetting(freeTimeSeconds: 3, countDownSeconds: 3, countDownTimes: 3), interval: interval, timeProvider: MockTimer.self)
        
        let sut = GoClockViewController(clock: clock)
        
        trackForMemoryLeaks(clock)
        trackForMemoryLeaks(sut)
        
        return (sut, clock)
    }
    
    private func record(snapshot: UIImage, named name: String,
                        file: StaticString = #filePath, line: UInt = #line) {
        guard let data = snapshot.pngData() else {
            XCTFail("Could not generate png data of snapshot", file: file, line: line)
            return
        }
        
        let snapshotURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
        
        do {
            try FileManager.default.createDirectory(at: snapshotURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to save snapshots with error: \(error)", file: file, line: line)
        }
    }
    
    private func assert(snapshot: UIImage, named name: String,
                        file: StaticString = #filePath, line: UInt = #line) {
        guard let data = snapshot.pngData() else {
            XCTFail("Could not generate png data of snapshot", file: file, line: line)
            return
        }
        
        let snapshotURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
        
        guard let storedData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the 'record' method before asserting", file: file, line: line)
            return
        }
        
        if data != storedData {
            let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(snapshotURL.lastPathComponent)
            
            try? data.write(to: temporarySnapshotURL)
            
            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL). Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }
}

extension UIViewController {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
    }
}
