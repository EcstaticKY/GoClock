///
/// Created by Zheng Kanyan on 2022/10/31.
/// 
///

import UIKit

final class SideView: UIView {
    var timeLabel: UILabel!
    
    convenience init(remainingSeconds: UInt) {
        self.init()
        timeLabel = UILabel()
        timeLabel.text = "\(remainingSeconds)"
    }
}
