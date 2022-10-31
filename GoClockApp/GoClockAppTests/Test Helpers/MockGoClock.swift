///
/// Created by Zheng Kanyan on 2022/10/31.
/// 
///

import Foundation
@testable import GoClock

class MockGoClock: GoClock {
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
