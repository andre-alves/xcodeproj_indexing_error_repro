//import Cartography
import CommonUI
import DrinkDetailsInterface
//import Kingfisher
import UIKit

public protocol DrinkDetailsViewProtocol: UIView, StatefulView {
    func configure(with viewModel: DrinkDetailsScene.DrinkDetails.ViewModel)
}

public final class DrinkDetailsView: UIView, DrinkDetailsViewProtocol {
    public var currentState: State?
    public lazy var stateView: UIView? = self

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10.0
        return stack
    }()

    public init() {
        super.init(frame: .zero)
        setupComponents()
        setupConstraints()
        setupExtraConfiguration()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        nil
    }

    public func configure(with viewModel: DrinkDetailsScene.DrinkDetails.ViewModel) {
        mainStack.removeAllArrangedSubviews()
        mainStack.addArrangedSubview(imageView(url: viewModel.drink.imageURL))
        mainStack.setSpacing(26.0, after: mainStack.arrangedSubviews[0])
        mainStack.addArrangedSubview(createHeaderLabel(text: Localization.DrinkDetailsView.ingredients))
        mainStack.addArrangedSubview(createContentLabel(text: viewModel.drink.ingredients))
        mainStack.setSpacing(26.0, after: mainStack.arrangedSubviews[2])
        mainStack.addArrangedSubview(createHeaderLabel(text: Localization.DrinkDetailsView.instructions))
        mainStack.addArrangedSubview(createContentLabel(text: viewModel.drink.instructions))
        mainStack.setSpacing(36.0, after: mainStack.arrangedSubviews[4])
        mainStack.addArrangedSubview(cheersImageView())
    }

    private func imageView(url: URL) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
//        imageView.kf.setImage(with: url)
        return imageView
    }

    private func cheersImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.cheers.image
        return imageView
    }
    
    private func createHeaderLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.text = text
        label.numberOfLines = 0
        return label
    }

    private func createContentLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.text = text
        label.numberOfLines = 0
        return label
    }
    
    private func setupComponents() {
        addSubview(mainStack)
    }

    private func setupConstraints() {
//        constrain(mainStack, self) { mainStack, superview in
//            mainStack.leading == superview.leading + 16
//            mainStack.trailing == superview.trailing - 16
//            mainStack.top == superview.topMargin + 16
//        }
    }

    private func setupExtraConfiguration() {
        backgroundColor = .white
    }
}

extension DrinkDetailsView: StatefulView {
    public func adapt(toState state: State, animated: Bool) {}
}

extension UIStackView {
    fileprivate class SpacingView: UIView {
        public weak var relatedView: UIView?
    }

    /// This is a helper method that helps to set spacing after a arrangedSubview for implementations that support iOS versions lower to iOS 11.
    /// If you choose to use this method **always** call `updateSpacingVisibilityIfNeccesary` when hiding or displaying the given
    /// arranged subview.
    fileprivate func setSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        setCustomSpacing(spacing, after: arrangedSubview)
    }

    fileprivate func createSpacingView(size: CGFloat, relatedTo view: UIView) -> SpacingView {
        let view = SpacingView()
        view.relatedView = view
//        switch axis {
//        case .horizontal:
//            constrain(view) { view in
//                view.width == size
//            }
//        case .vertical:
//            constrain(view) { view in
//                view.height == size
//            }
//        @unknown default:
//            break
//        }
        return view
    }

    fileprivate func updateSpacingVisibilityIfNeccesary(after arrangedSubview: UIView) {
        guard let subviewIndex = arrangedSubviews.firstIndex(of: arrangedSubview), arrangedSubviews.count > subviewIndex + 1 else { return }
    }

    @discardableResult
    fileprivate func removeAllArrangedSubviews() -> [UIView] {
        let removedSubviews = arrangedSubviews.reduce([]) { removedSubviews, subview -> [UIView] in
            subview.removeFromSuperview()
            return removedSubviews + [subview]
        }
        return removedSubviews
    }
}
