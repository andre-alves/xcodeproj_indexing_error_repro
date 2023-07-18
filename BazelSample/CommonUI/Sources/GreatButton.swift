////import Cartography
//import Foundation
//import UIKit
////import Lottie
//
//public protocol ButtonProtocol: UIControl {
//    var mainText: String? { get set }
//    var mode: GreatButton.CTAMode { get set }
//    var secondaryText: String? { get set }
//    var loadingView: AnimationView { get set }
//    var enabledTextColor: UIColor { get set }
//    var disabledTextColor: UIColor { get set }
//    var enabledBackgroundColor: UIColor { get set }
//    var disabledBackgroundColor: UIColor { get set }
//    var enabledBorderColor: UIColor { get set }
//    var disabledBorderColor: UIColor { get set }
//    var buttonCornerRadius: CGFloat { get set }
//    var horizontalMargins: CGFloat { get set }
//    var leftIcon: UIImage? { get set }
//    var isLoading: Bool { get }
//
//    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event)
//    func setLoadingVisibility(to isVisible: Bool)
//}
//
//public protocol ButtonWithState where Self: GreatButton {
//    func change(to state: GreatButton.ButtonState)
//}
//
//public final class GreatButton: UIControl, ButtonProtocol {
//    public enum CTAMode {
//        case oneTitleCentered
//        case twoTitles
//    }
//
//    public enum ButtonState {
//        case enabled
//        case disabled /// Disable visually and the tap observer
//        case inactive /// Disable only visually but still call tap observer
//    }
//
//    private var stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.isUserInteractionEnabled = false
//        stackView.axis = .horizontal
//        stackView.isAccessibilityElement = false
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
//
//    private var mainLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.font = UIFont.preferredFont(forTextStyle: .title1)
//        label.textColor = .lightGray
//        label.isUserInteractionEnabled = false
//        label.isAccessibilityElement = false
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.5
//        return label
//    }()
//
//    private var secondaryLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .right
//        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
//        label.textColor = .lightGray
//        label.isUserInteractionEnabled = false
//        label.isAccessibilityElement = false
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.5
//        return label
//    }()
//
//    private lazy var leftIconImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    // MARK: - Public properties
//
//    public var mode: CTAMode = .oneTitleCentered {
//        didSet {
//            mode == .oneTitleCentered ? hideSecondLabel() : showSecondLabel()
//        }
//    }
//
//    public var mainText: String? {
//        didSet {
//            mainLabel.text = mainText
//            setupAccessibilityLabel()
//        }
//    }
//
//    public var secondaryText: String? {
//        didSet {
//            secondaryLabel.text = secondaryText
//            setupAccessibilityLabel()
//        }
//    }
//
////    public lazy var loadingView: AnimationView = {
////        let loading = AnimationView(filePath: Files.loadingStateJson.path)
////        loading.loopMode = .loop
////        loading.contentMode = .center
////        return loading
////    }()
//
//    public var enabledTextColor: UIColor = .gray
//    public var disabledTextColor: UIColor = .darkGray
//
//    public var enabledBackgroundColor: UIColor = .red
//    public var disabledBackgroundColor: UIColor = .gray
//
//    public var enabledBorderColor: UIColor = .clear
//    public var disabledBorderColor: UIColor = .clear
//
//    public private(set) var isLoading: Bool = false
//
//    public var buttonCornerRadius: CGFloat = 4 {
//        didSet {
//            layer.cornerRadius = buttonCornerRadius
//        }
//    }
//
//    private var buttonState: GreatButton.ButtonState = .enabled
//
//    let horizontalMarginsGroup = ConstraintGroup()
//    public var horizontalMargins: CGFloat = 16 {
//        didSet {
//            constrainHorizontalStackViewMargins()
//        }
//    }
//
//    public override var isEnabled: Bool {
//        didSet {
//            buttonState = isEnabled ? .enabled : .disabled
//            setStyle(isActive: isEnabled)
//        }
//    }
//
//    public var leftIcon: UIImage? {
//        didSet {
//            if let unIcon = leftIcon {
//                leftIconImageView.image = unIcon.withRenderingMode(.alwaysTemplate)
//                leftIconImageView.tintColor = isEnabled ? enabledTextColor : disabledTextColor
//                setupLeftIconImageView()
//            } else {
//                leftIconImageView.removeFromSuperview()
//            }
//        }
//    }
//
//    public func setLoadingVisibility(to isVisible: Bool) {
//        if isVisible {
//            loadingView.setColor(enabledTextColor)
//            loadingView.backgroundColor = enabledBackgroundColor
//            setupLoadingView()
//            loadingView.play()
//            isLoading = true
//        } else {
//            loadingView.stop()
//            loadingView.removeFromSuperview()
//            isLoading = false
//        }
//
//        layoutIfNeeded()
//    }
//
//    // MARK: - Init
//
//    public init(mode: CTAMode) {
//        self.mode = mode
//        super.init(frame: .zero)
//        setup()
//
//        isAccessibilityElement = true
//        accessibilityTraits = UIAccessibilityTraits.button
//        setupAccessibilityLabel()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    @available(*, unavailable)
//    required init?(coder aDecoder: NSCoder) {
//        nil
//    }
//
//    // MARK: - Setup
//
//    private func setup() {
//        setupView()
//        setupStackView()
//    }
//
//    private func setupView() {
//        backgroundColor = enabledBackgroundColor
//        isEnabled = true
//        layer.cornerRadius = buttonCornerRadius
//        clipsToBounds = true
//    }
//
//    private func setupStackView() {
//        addSubview(stackView)
//
//        constrain(stackView, self) { stack, superview in
//            stack.top <= superview.top
//            stack.bottom <= superview.bottom
//            stack.centerX == superview.centerX
//            stack.centerY == superview.centerY
//        }
//        constrainHorizontalStackViewMargins()
//
//        stackView.addArrangedSubview(mainLabel)
//        switch mode {
//        case .oneTitleCentered:
//            hideSecondLabel()
//        case .twoTitles:
//            showSecondLabel()
//        }
//    }
//
//    private func setupLoadingView() {
//        addSubview(loadingView)
//        constrain(self, loadingView) { view, loading in
//            loading.edges == view.edges
//        }
//    }
//
//    private func setupLeftIconImageView() {
//        mainLabel.textAlignment = .left
//        stackView.distribution = .fill
//        stackView.spacing = 8
//        stackView.insertArrangedSubview(leftIconImageView, at: 0)
//
//        constrain(leftIconImageView) { imageView in
//            imageView.height == 30
//            imageView.width == 30
//        }
//
//        constrain(clear: horizontalMarginsGroup)
//    }
//
//    private func constrainHorizontalStackViewMargins() {
//        constrain(stackView, self, replace: horizontalMarginsGroup) { stack, superview in
//            stack.leading <= superview.leading + horizontalMargins
//            stack.trailing <= superview.trailing - horizontalMargins
//        }
//    }
//
//    private func hideSecondLabel() {
//        secondaryLabel.isHidden = true
//        mainLabel.textAlignment = .center
//    }
//
//    private func showSecondLabel() {
//        secondaryLabel.isHidden = false
//        stackView.addArrangedSubview(secondaryLabel)
//        mainLabel.textAlignment = .left
//        secondaryLabel.textAlignment = .right
//    }
//
//    private func setupAccessibilityLabel() {
//        var enabledText: String = ""
//        var disabledText: String = ""
//
//        if let main = mainText, main.isEmpty == false {
//            enabledText = main
//        }
//        if let secondary = secondaryText, secondary.isEmpty == false {
//            enabledText.append(" " + secondary)
//        }
//
//        guard enabledText.isEmpty == false else {
//            accessibilityLabel = isEnabled ? enabledText : "inativo"
//            return
//        }
//
//        disabledText = enabledText + ". " + "inativo"
//
//        switch buttonState {
//        case .disabled, .inactive:
//            accessibilityLabel = disabledText
//        case .enabled:
//            accessibilityLabel = enabledText
//        }
//    }
//
//    private func setStyle(isActive: Bool) {
//        backgroundColor = isActive ? enabledBackgroundColor : disabledBackgroundColor
//        mainLabel.textColor = isActive ? enabledTextColor : disabledTextColor
//        secondaryLabel.textColor = isActive ? enabledTextColor : disabledTextColor
//        setupAccessibilityLabel()
//    }
//}
//
//// MARK: - ButtonWithState
//
//extension GreatButton: ButtonWithState {
//    public func change(to state: GreatButton.ButtonState) {
//        switch state {
//        case .enabled:
//            isEnabled = true
//            buttonState = state
//        case .disabled:
//            isEnabled = false
//            buttonState = state
//        case .inactive:
//            isEnabled = true
//            buttonState = state
//            setStyle(isActive: false)
//        }
//    }
//}
