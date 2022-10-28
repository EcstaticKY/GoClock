///
/// Created by Zheng Kanyan on 2022/10/25.
/// 
///

import Foundation

let DefaultInterval = 0.1

class GoTimer {
    private let interval: TimeInterval
    private let timeProvider: Timer.Type
    private var ticked: ((TimeInterval) -> Void)?
    private var timer: Timer?
    
    init(interval: TimeInterval = DefaultInterval, timeProvider: Timer.Type = Timer.self) {
        self.timeProvider = timeProvider
        self.interval = interval
    }
    
    func setTickedClosure(_ ticked: @escaping (TimeInterval) -> Void) {
        self.ticked = ticked
    }
    
    func fire() {
        if let timer = timer {
            timer.fire()
        } else {
            timer = timeProvider.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.ticked?(self.interval)
            }
        }
    }
    
    func invalidate() {
        timer?.invalidate()
    }
}
