///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import UIKit
import GoClock

final class GoClockViewController: UIViewController {
    private var clock: GoClock?
    private var hostSideBottomConstraint: NSLayoutConstraint?
    
    convenience init(clock: GoClock) {
        self.init()
        self.clock = clock
        clock.setUpdatedClosure { [weak self] in
            self?.updateSides()
        }
    }
    
    override func viewDidLoad() {
        setUpView()
        setUpConstraints()
    }
    
    func setUpView() {
        guard let _ = clock else { return }
        
        view.addSubview(hostSideView)
        view.addSubview(guestSideView)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            hostSideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostSideView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostSideView.topAnchor.constraint(equalTo: view.topAnchor),
            
            guestSideView.topAnchor.constraint(equalTo: hostSideView.bottomAnchor),
            guestSideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            guestSideView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            guestSideView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostSideBottomConstraint = NSLayoutConstraint(item: hostSideView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.25, constant: 0)
        hostSideBottomConstraint?.isActive = true
    }
    
    private func updateSides() {
        guard let clock = clock else { return }
        
        hostSideView.timeLabel.text = "\(clock.sides[0].remainingSeconds)"
        guestSideView.timeLabel.text = "\(clock.sides[1].remainingSeconds)"
        
        hostSideBottomConstraint?.isActive = false
        
        if clock.currentRunningIndex == 0 {
            hostSideBottomConstraint = NSLayoutConstraint(item: hostSideView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.75, constant: 0)
        } else {
            hostSideBottomConstraint = NSLayoutConstraint(item: hostSideView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.25, constant: 0)
        }
        hostSideBottomConstraint?.isActive = true
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
    
    lazy var hostSideView: SideView = ({
        let view = SideView(remainingSeconds: clock!.sides[0].remainingSeconds, isHostSide: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        view.addGestureRecognizer(tapRecognizer)
        
        return view
    })()
    
    lazy var guestSideView: SideView = ({
        let view = SideView(remainingSeconds: clock!.sides[1].remainingSeconds, isHostSide: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        view.addGestureRecognizer(tapRecognizer)
        
        return view
    })()
}

