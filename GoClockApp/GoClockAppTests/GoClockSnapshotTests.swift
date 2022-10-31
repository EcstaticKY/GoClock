///
/// Created by Zheng Kanyan on 2022/10/31.
/// 
///

import XCTest
@testable import GoClockApp

let DefaultTotalSeconds: UInt = 30

final class GoClockSnapshotTests: XCTestCase {

    func testExample() throws {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        record(snapshot: sut.snapshot(), named: "DEFAULT_CLOCK")
    }

    // MARK: -- Helpers

    private func makeSUT() -> (sut: GoClockViewController, clock: MockGoClock) {
        let side0 = MockSide(remainingSeconds: DefaultTotalSeconds)
        let side1 = MockSide(remainingSeconds: DefaultTotalSeconds)
        let clock = MockGoClock(sides: [side0, side1])
        let sut = GoClockViewController(clock: clock)
        
        trackForMemoryLeaks(side0)
        trackForMemoryLeaks(side1)
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
}

extension UIViewController {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
    }
}
