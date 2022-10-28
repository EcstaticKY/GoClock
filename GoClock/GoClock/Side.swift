///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import Foundation

public protocol Side {
    var remainingSeconds: UInt { get }
    
    func setUpdatedClosure(_ updated: @escaping () -> Void)
    
    func start()
    func stop()
}

public class ConcreteSide: Side {
    
    private let timer: GoTimer
    public var remainingSeconds: UInt {
        let seconds = floor(remainingTime)
        return remainingTime - seconds < DefaultInterval / 2 ? UInt(seconds) : UInt(seconds) + 1
    }
    private var remainingTime: TimeInterval
    private var updated: (() -> Void)?
    
    public init(totalSeconds: UInt, timer: GoTimer) {
        self.timer = timer
        self.remainingTime = Double(totalSeconds)
        timer.setTickedClosure { [weak self] interval in
            guard let self = self else { return }
            self.remainingTime -= interval
            if abs(self.remainingTime - Double(self.remainingSeconds)) < DefaultInterval / 2 {
                if self.remainingSeconds == 0 {
                    self.timer.invalidate()
                }
                self.updated?()
            }
        }
    }
    
    public func setUpdatedClosure(_ updated: @escaping () -> Void) {
        self.updated = updated
    }
    
    public func start() {
        guard remainingSeconds > 0 || abs(remainingTime - Double(remainingSeconds)) > DefaultInterval / 2 else {
            return
        }
        timer.fire()
    }
    
    public func stop() {
        timer.invalidate()
    }
}
