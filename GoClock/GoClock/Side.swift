///
/// Created by Zheng Kanyan on 2022/10/24.
/// 
///

import Foundation

public struct Side: Equatable {
    
    public init(remainingSeconds: UInt, updatedBlock: @escaping () -> Void) {
        self.remainingSeconds = remainingSeconds
        self.remainingSecondsInDouble = Double(remainingSeconds)
        if remainingSeconds == 0 {
            timedOut = true
        }
        
        self.updatedBlock = updatedBlock
    }
    
    public var remainingSeconds: UInt
    private let updatedBlock: () -> Void
    private var remainingSecondsInDouble: Double
    private var timedOut = false
    
    public func start() {
        
    }
    
    public func stop() {
        
    }
    
    public static func == (lhs: Side, rhs: Side) -> Bool {
        lhs.timedOut == rhs.timedOut
        && lhs.remainingSecondsInDouble == lhs.remainingSecondsInDouble
    }
}
