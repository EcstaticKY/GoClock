///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import Foundation

class GoClock {
    let sides: [Side]
    var currentWaitingIndex = 0
    var updated: (() -> Void)?
    
    init(sides: [Side]) {
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
    
    func setUpdatedClosure(_ updated: @escaping () -> Void) {
        self.updated = updated
    }
    
    func switchSide() {
        sides[currentWaitingIndex].start()
        currentWaitingIndex = currentWaitingIndex == 0 ? 1 : 0
        sides[currentWaitingIndex].stop()
    }
}
