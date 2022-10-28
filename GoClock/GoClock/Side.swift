///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import Foundation

protocol Side {
    var remainingSeconds: UInt { get }
    
    func setUpdatedClosure(_ updated: @escaping () -> Void)
    
    func start()
    func stop()
}

class ConcreteSide: Side, Equatable {
    
    private let timer: GoTimer
    var remainingSeconds: UInt {
        let seconds = floor(remainingTime)
        return remainingTime - seconds < DefaultInterval / 2 ? UInt(seconds) : UInt(seconds) + 1
    }
    private var remainingTime: TimeInterval
    private var updated: (() -> Void)?
    
    init(totalSeconds: UInt, timer: GoTimer) {
        self.timer = timer
        self.remainingTime = Double(totalSeconds)
        timer.setTickedClosure { [weak self] interval in
            guard let self = self else { return }
            self.remainingTime -= interval
            print("Time: \(self.remainingTime), Seconds: \(self.remainingSeconds)")
            if abs(self.remainingTime - Double(self.remainingSeconds)) < DefaultInterval / 2 {
                print("===== It's Time to Update")
                if self.remainingSeconds == 0 {
                    self.timer.invalidate()
                }
                self.updated?()
            }
        }
    }
    
    func setUpdatedClosure(_ updated: @escaping () -> Void) {
        self.updated = updated
    }
    
    func start() {
        guard remainingSeconds > 0 || abs(remainingTime - Double(remainingSeconds)) > DefaultInterval / 2 else {
            return
        }
        timer.fire()
    }
    
    func stop() {
        timer.invalidate()
    }
    
    static func == (lhs: ConcreteSide, rhs: ConcreteSide) -> Bool {
        lhs.remainingTime == rhs.remainingTime
    }
}
