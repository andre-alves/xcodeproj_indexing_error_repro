//import Cartography
import UIKit

public struct EmptyState: Equatable {
    public let image: UIImage?
    public let title: String
    public let subtitle: String
    public let buttonTitle: String?
    public weak var buttonDelegate: EmptyStateViewDelegate?

    public init(image: UIImage?, title: String, subtitle: String, buttonTitle: String? = nil, buttonDelegate: EmptyStateViewDelegate? = nil) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.buttonDelegate = buttonDelegate
    }

    public static func with(error: Error?, buttonDelegate: EmptyStateViewDelegate?) -> EmptyState {
        let title: String = Localization.EmptyState.Error.title
        let image: UIImage? = nil
        let subtitle: String = Localization.EmptyState.Error.subtitle
        let buttonTitle: String = Localization.EmptyState.Error.tryAgain

        return EmptyState(
            image: image,
            title: title,
            subtitle: subtitle,
            buttonTitle: buttonTitle,
            buttonDelegate: buttonDelegate
        )
    }

    public static func == (lhs: EmptyState, rhs: EmptyState) -> Bool {
        lhs.image == rhs.image &&
               lhs.title == rhs.title &&
               lhs.subtitle == rhs.subtitle &&
               lhs.buttonTitle == rhs.buttonTitle &&
               lhs.buttonDelegate === rhs.buttonDelegate
    }
}

public protocol EmptyStateViewDelegate: AnyObject {
    /// Informs that the EmptyStateView's button was touched.
    /// - Parameter emptyState: The EmptyStateMode rendered onto the view once the button was touched.
    func emptyStateViewButtonTouched(forState emptyState: EmptyState)
}

public final class EmptyStateView: UIView {

    public private(set) var emptyState: EmptyState?

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        return titleLabel
    }()

    private let subtitleLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        detailLabel.textColor = .darkGray
        detailLabel.textAlignment = .center
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.numberOfLines = 0
        return detailLabel
    }()

//    private let button: GreatButton = {
//        let button = GreatButton(mode: .oneTitleCentered)
//        button.enabledBackgroundColor = .clear
//        button.enabledTextColor = .red
//        button.isEnabled = true
//        return button
//    }()

    public init() {
        super.init(frame: CGRect.zero)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        constrainStack()
        constrainImage()
        constrainButton()
        backgroundColor = .lightGray
        alpha = 0
    }

    private func constrainStack() {
        addSubview(stackView)
//        constrain(stackView, self) { view, superview in
//            view.top >= superview.top
//            view.bottom <= superview.bottom
//            view.leading >= superview.leading + 32
//            view.trailing <= superview.trailing - 32
//            view.centerX == superview.centerX
//            view.centerY == superview.centerY
//        }
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
//        stackView.addArrangedSubview(button)
    }

    private func constrainImage() {
//        constrain(imageView) { view in
//            view.width == 65 ~ LayoutPriority.defaultLow
//            view.height == 65 ~ LayoutPriority.defaultLow
//        }
    }

    private func constrainButton() {
//        constrain(button) { view in
//            view.height == 50
//        }
//        button.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
    }

    @objc private func buttonTouched() {
        guard let emptyState = emptyState else {
            return
        }
        DispatchQueue.main.async {
            emptyState.buttonDelegate?.emptyStateViewButtonTouched(forState: emptyState)
        }
    }

    /// Updates the EmptyStateView.
    /// - Parameter emptyState: The information to be used when rendering this view.
    public func render(emptyState: EmptyState) {
        self.emptyState = emptyState
        nameLabel.text = emptyState.title
        subtitleLabel.text = emptyState.subtitle
        if let image = emptyState.image {
            imageView.isHidden = false
            imageView.image = image
        } else {
            imageView.isHidden = true
        }
//        if let buttonTitle = emptyState.buttonTitle {
//            button.isHidden = false
//            button.mainText = buttonTitle
//        } else {
//            button.isHidden = true
//        }
    }
}

extension EmptyStateView: AlphaAnimation {}

private struct AssociatedKeys {
    static var emptyStateViewKey = "emptyStateViewKey"
}

extension UIView {
    private var _emptyStateView: EmptyStateView? {
        guard let emptyStateView = objc_getAssociatedObject(self, &AssociatedKeys.emptyStateViewKey) as? EmptyStateView else {
            let view = EmptyStateView()
            let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &AssociatedKeys.emptyStateViewKey, view, policy)
            return view
        }
        return emptyStateView
    }

    /// Because we allow to override prepareEmptyState for StatefulObject
    /// we need to allow hideEmptyStateView to be called outside the UI module
    public func hideEmptyStateView(animated: Bool = true) {
        _emptyStateView?.hide(animated: animated) { [weak self] in
            self?._emptyStateView?.removeFromSuperview()
        }
    }

    /// Because we allow to override prepareEmptyState for StatefulObject
    /// we need to allow showEmptyStateView to be called outside the UI module
    public func showEmptyStateView(_ emptyState: EmptyState, animated: Bool = true) {
        hideEmptyStateView(animated: false)
        guard let view = _emptyStateView else {
            return
        }
        addSubview(view)
//        constrain(view, self) { view, superview in
//            view.edges == superview.edges
//        }
        view.render(emptyState: emptyState)
        view.show(animated: animated)
    }
}
