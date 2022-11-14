//
//  GoClockExTests.swift
//  GoClockTests
//
//  Created by zky on 2022/11/13.
//

import XCTest
@testable import GoClock

public class GoClockEx {
    public enum State {
        case ready, running, pausing, timedOut
    }
    
    public var state = State.ready
    
    private var sides: [ConcreteSide]
    
    init(sides: [ConcreteSide]) {
        self.sides = sides
    }
}

final class GoClockExTests: XCTestCase {

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
}
