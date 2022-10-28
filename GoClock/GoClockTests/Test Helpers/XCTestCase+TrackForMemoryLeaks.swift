///
/// Created by Zheng Kanyan on 2022/10/27.
/// 
///

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "\(String(describing: instance)) should been release, potential memory leaks detected.", file: file, line: line)
        }
    }
}
