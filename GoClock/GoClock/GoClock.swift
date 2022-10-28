///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import Foundation

public class GoClock {
    public let sides: [Side]
    var currentWaitingIndex = 0
    var updated: (() -> Void)?
    
    public init(sides: [Side]) {
        self.sides = sides
        sides.enumerated().forEach { (index, side) in
            side.setUpdatedClosure { [weak self] in
                guard let self = self, self.currentWaitingIndex != index else {
                    return
                }
                
                self.updated?()
            }
        }
    }
    
    public func setUpdatedClosure(_ updated: @escaping () -> Void) {
        self.updated = updated
    }
    
    public func switchSide() {
        sides[currentWaitingIndex].start()
        currentWaitingIndex = currentWaitingIndex == 0 ? 1 : 0
        sides[currentWaitingIndex].stop()
    }
}
