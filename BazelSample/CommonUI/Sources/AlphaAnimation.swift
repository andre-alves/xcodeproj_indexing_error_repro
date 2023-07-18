import UIKit

public protocol AlphaAnimation {
    var animationDuration: TimeInterval { get }

    func show(animated: Bool)
    func hide(animated: Bool, completion: (() -> Void)?)
    func prepareToShow()
    func prepareToHide()
}

extension AlphaAnimation where Self: UIView {

    public var animationDuration: TimeInterval {
        0.25
    }

    public func show(animated: Bool = true) {
        layer.removeAllAnimations()
        prepareToShow()

        guard animated else {
            alpha = 1
            return
        }

        let animations: () -> Void = { [weak self] in
            self?.alpha = 1
        }

        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: animations,
                       completion: nil)
    }

    public func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        func onFinish() {
            prepareToHide()
            completion?()
        }
        layer.removeAllAnimations()

        guard animated else {
            alpha = 0
            onFinish()
            return
        }

        let animations: () -> Void = { [weak self] in
            self?.alpha = 0
        }

        let completion: (Bool) -> Void = { _ in
            onFinish()
        }

        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: animations,
                       completion: completion)
    }

    public func prepareToShow() {}
    public func prepareToHide() {}
}
