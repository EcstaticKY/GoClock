///
/// Created by Zheng Kanyan on 2022/10/31.
/// 
///

import UIKit

final class SideView: UIView {
    var timeLabel: UILabel!
    
    convenience init(remainingSeconds: UInt, isHostSide: Bool) {
        self.init()
        
        timeLabel = UILabel()
        timeLabel.font = .preferredFont(forTextStyle: .largeTitle)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if isHostSide {
            timeLabel.textColor = .white
        } else {
            timeLabel.textColor = .black
        }
        
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        timeLabel.text = "\(remainingSeconds)"
    }
}
