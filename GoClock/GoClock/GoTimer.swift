///
/// Created by Zheng Kanyan on 2022/10/26.
/// 
///

import Foundation

public protocol GoTimer {
    init(timeElapsed: @escaping (Double) -> Void)
    
    func fire()
    func invalidate()
}
