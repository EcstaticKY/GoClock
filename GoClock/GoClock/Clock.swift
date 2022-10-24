///
/// Created by Zheng Kanyan on 2022/10/19.
/// 
///

import Foundation

//public class Clock {
//    public var sides: [Side]
//    public var currentWaitingSide = 0
//    
//    private var updatedBlock: (() -> Void)
//    
//    public convenience init(remainingSeconds: Int,
//                            updatedBlock: @escaping () -> Void) {
//        self.init(remainingSecondsArray: [remainingSeconds, remainingSeconds],
//                  updatedBlock: updatedBlock)
//    }
//    
//    public init(remainingSecondsArray: [Int],
//                updatedBlock: @escaping () -> Void) {
//        sides = [Side(remainingSeconds: remainingSecondsArray[0]),
//                 Side(remainingSeconds: remainingSecondsArray[1])]
//        self.updatedBlock = updatedBlock
//    }
//    
//    public func tickle() {
//        currentWaitingSide = currentWaitingSide == 0 ? 1 : 0
//        updatedBlock()
//        
//        sides.enumerated().forEach { (index, side) in
//            if index == currentWaitingSide {
//                side.start()
//            } else {
//                side.stop()
//            }
//        }
//    }
//}
