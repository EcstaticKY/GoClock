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
        setUpConstraints()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        hostSideView.addGestureRecognizer(tapRecognizer)
        guestSideView.addGestureRecognizer(tapRecognizer)
    }
    
    func setUpView() {
        guard let clock = clock else { return }
        
        view.backgroundColor = .cyan
        
        hostSideView = SideView(remainingSeconds: clock.sides[0].remainingSeconds, isHostSide: true)
        hostSideView.backgroundColor = .black
        hostSideView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostSideView)
        
        guestSideView = SideView(remainingSeconds: clock.sides[1].remainingSeconds, isHostSide: false)
        guestSideView.backgroundColor = .white
        guestSideView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guestSideView)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            hostSideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostSideView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostSideView.topAnchor.constraint(equalTo: view.topAnchor),
            hostSideView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            guestSideView.topAnchor.constraint(equalTo: hostSideView.bottomAnchor),
            guestSideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            guestSideView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            guestSideView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

