//import Cartography
import UIKit
//import Lottie

public final class LoadingView: UIView {

//    private let animationView: AnimationView = {
//        let loading = AnimationView(filePath: Files.loadingStateJson.path)
//        loading.loopMode = .loop
//        loading.contentMode = .center
//        loading.backgroundBehavior = .pauseAndRestore
//        return loading
//    }()

    public init(backgroundColor: UIColor = .white, loadingColor: UIColor = .red) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
//        self.animationView.setColor(loadingColor)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func setup() {
        constrainLoadingView()
        alpha = 0
    }

    private func constrainLoadingView() {
//        addSubview(animationView)
//        constrain(animationView, self) { view, superview in
//            view.center == superview.center
//        }
    }
}

extension LoadingView: AlphaAnimation {
    public func prepareToShow() {
//        animationView.play()
    }

    public func prepareToHide() {
//        animationView.stop()
    }
}

private struct AssociatedKeys {
    static var loadingViewKey = "loadingViewKey"
}

extension UIView {
    private var _loadingView: LoadingView? {
        guard let loadingView = objc_getAssociatedObject(self, &AssociatedKeys.loadingViewKey) as? LoadingView else {
            let view = LoadingView()
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &AssociatedKeys.loadingViewKey, view, policy)
            return view
        }
        return loadingView
    }

    /// Because we allow to override prepareLoadingState for StatefulObject
    /// we need to allow hideLoadingView to be called outside the UI module
    public func hideLoadingView(animated: Bool = true) {
        _loadingView?.hide(animated: animated) { [weak self] in
            self?._loadingView?.removeFromSuperview()
        }
    }

    /// Because we allow to override prepareLoadingState for StatefulObject
    /// we need to allow showLoadingView to be called outside the UI module
    public func showLoadingView(animated: Bool = true) {
        hideLoadingView(animated: false)
        guard let view = _loadingView else {
            return
        }
        addSubview(view)
//        constrain(view, self) { view, superview in
//            view.edges == superview.edges
//        }
        view.show(animated: animated)
    }
}

//extension AnimationView {
//    func setColor(_ color: UIColor) {
//        let colorCallbackDelegate = ColorValueProvider(color.lottieColorValue)
//        setValueProvider(colorCallbackDelegate, keypath: AnimationKeypath(keypath: "Left.Ellipse.Fill.Color"))
//        setValueProvider(colorCallbackDelegate, keypath: AnimationKeypath(keypath: "Mid.Ellipse.Fill.Color"))
//        setValueProvider(colorCallbackDelegate, keypath: AnimationKeypath(keypath: "Right.Ellipse.Fill.Color"))
//    }
//}
