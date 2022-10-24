///
/// Created by Zheng Kanyan on 2022/10/24.
/// 
///

import Foundation

public class ClockTimer {
    private let timeUpdated: () -> Void
    
    public init(timeUpdated: @escaping () -> Void) {
        self.timeUpdated = timeUpdated
    }
    
    private var timer: Timer?
    
    public func fire() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                self.timeUpdated()
            })
        } else {
            timer?.fire()
        }
    }
}
