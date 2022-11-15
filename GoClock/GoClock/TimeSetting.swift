///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import Foundation

public struct TimeSetting {
    public init(freeTimeSeconds: UInt, countDownSeconds: UInt, countDownTimes: UInt) {
        self.freeTimeSeconds = freeTimeSeconds
        self.countDownSeconds = countDownSeconds
        self.countDownTimes = countDownTimes
    }
    
    public let freeTimeSeconds: UInt
    public let countDownSeconds: UInt
    public let countDownTimes: UInt
}
