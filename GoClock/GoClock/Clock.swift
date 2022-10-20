///
/// Created by Zheng Kanyan on 2022/10/19.
/// 
///

import Foundation

public struct Clock {
    public var sides = [Side]()
    public var currentWaitingSide = 0
    
    public init() {
        sides = [Side(), Side()]
    }
    
    func tickle() {
        
    }
}

public struct Side: Equatable {
    public init() { }
    
    public var remainingSeconds = 30
}
