///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import Foundation

public class GoClock {
    public let sides: [ConcreteSide]
    public var currentRunningIndex = 1
    var updated: (() -> Void)?
    
    public init(sides: [ConcreteSide]) {
        self.sides = sides
        sides.enumerated().forEach { (index, side) in
            side.setUpdatedClosure { [weak self] in
                guard let self = self, self.currentRunningIndex == index else {
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
        sides[currentRunningIndex].stop()
        currentRunningIndex = currentRunningIndex == 0 ? 1 : 0
        sides[currentRunningIndex].start()
        
        updated?()
    }
}
