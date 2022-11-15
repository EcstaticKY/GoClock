///
/// Created by Zheng Kanyan on 2022/10/28.
/// 
///

import UIKit
import GoClock

extension GoClockEx.State {
    var currentSideIsHost: Bool {
        switch self {
        case .ready: return false
        case .running(let atHost): return atHost
        case .pausing(let atHost): return atHost
        case .timedOut(let atHost): return atHost
        }
    }
}

final class GoClockViewController: UIViewController {
    private var clock: GoClockEx?
    private var hostSideBottomConstraint: NSLayoutConstraint?
    
    convenience init(clock: GoClockEx) {
        self.init()
        self.clock = clock
        clock.setUpdatedBlock { [weak self] in
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
        
        hostSideView.timeLabel.text = "\(clock.hostRemainingTime.currentSeconds)"
        guestSideView.timeLabel.text = "\(clock.guestRemainingTime.currentSeconds)"
        
        hostSideBottomConstraint?.isActive = false
        if clock.state.currentSideIsHost {
            hostSideBottomConstraint = NSLayoutConstraint(item: hostSideView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.75, constant: 0)
        } else {
            hostSideBottomConstraint = NSLayoutConstraint(item: hostSideView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.25, constant: 0)
        }
        hostSideBottomConstraint?.isActive = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let sender = sender, let clock = clock else { return }
        
        switch clock.state {
        case .ready:
            if sender.view == guestSideView {
                clock.start()
            }
        case .running(let atHost):
            if (atHost && sender.view == hostSideView) || (!atHost && sender.view == guestSideView) {
                clock.switchSide()
            }
        default:
            return
        }
    }
    
    lazy var hostSideView: SideView = ({
        let view = SideView(remainingSeconds: clock!.hostRemainingTime.currentSeconds, isHostSide: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        view.addGestureRecognizer(tapRecognizer)
        
        return view
    })()
    
    lazy var guestSideView: SideView = ({
        let view = SideView(remainingSeconds: clock!.guestRemainingTime.currentSeconds, isHostSide: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        view.addGestureRecognizer(tapRecognizer)
        
        return view
    })()
}

