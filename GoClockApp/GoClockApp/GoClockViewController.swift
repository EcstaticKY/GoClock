///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import UIKit
import GoClock

final class GoClockViewController: UIViewController {
    private var clock: GoClock?
    
    convenience init(clock: GoClock) {
        self.init()
        self.clock = clock
        clock.setUpdatedClosure { [weak self] in
            self?.setUpView()
        }
    }
    
    var hostSideView: SideView!
    var guestSideView: SideView!
    
    override func viewDidLoad() {
        setUpView()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        hostSideView.addGestureRecognizer(tapRecognizer)
        guestSideView.addGestureRecognizer(tapRecognizer)
    }
    
    func setUpView() {
        guard let clock = clock else { return }
        hostSideView = SideView(remainingSeconds: clock.sides[0].remainingSeconds)
        guestSideView = SideView(remainingSeconds: clock.sides[1].remainingSeconds)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let sender = sender, let clock = clock else { return }
        guard clock.sides.filter({ $0.remainingSeconds == 0 }).isEmpty else {
            return
        }
        if sender.view == hostSideView {
            guard clock.currentRunningIndex == 0 else { return }
        } else {
            guard clock.currentRunningIndex == 1 else { return }
        }
        clock.switchSide()
    }
}

