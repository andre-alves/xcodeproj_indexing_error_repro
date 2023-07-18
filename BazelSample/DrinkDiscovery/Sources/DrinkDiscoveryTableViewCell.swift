import Cartography
import CommonUI
import Kingfisher
import UIKit

final class DrinkDiscoveryTableViewCell: UITableViewCell {
    struct ViewModel {
        let title: String
        let subtitle: String
        let imageURL: URL
    }

    // MARK: - Subviews

    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .black
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        return view
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonUI.Asset.rightArrow.image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponents()
        setupConstraints()
        setupExtraConfiguration()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Internal methods

    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        thumbImageView.kf.cancelDownloadTask()
        thumbImageView.kf.setImage(with: viewModel.imageURL)
    }
    
    private func setupComponents() {
        contentView.addSubview(thumbImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(arrowImageView)
    }

    private func setupConstraints() {
        constrain(separatorView, contentView) { separator, superview in
            separator.bottom == superview.bottom
            separator.leading == superview.leading + 16
            separator.trailing == superview.trailing - 16
            separator.height == 1
        }

        constrain(thumbImageView, titleLabel, subtitleLabel, separatorView) { thumb, title, subtitle, separator in
            thumb.top == title.top
            thumb.bottom == subtitle.bottom
            thumb.leading == separator.leading
            thumb.width == thumb.height
        }

        constrain(titleLabel, thumbImageView, separatorView, contentView) { title, thumb, separator, superview in
            title.top == superview.top + 16
            title.leading == thumb.trailing + 8
            title.trailing == separator.trailing
        }

        constrain(subtitleLabel, titleLabel, separatorView) { subtitle, title, separator in
            subtitle.top == title.bottom + 4
            subtitle.leading == title.leading
            subtitle.trailing == title.trailing
            subtitle.bottom == separator.top - 16
        }

        constrain(arrowImageView, titleLabel, separatorView, contentView) { arrow, title, separator, superview in
            arrow.trailing == separator.trailing
            arrow.leading >= title.trailing - 4
            arrow.centerY == superview.centerY
            arrow.height == 8
            arrow.width == 4
        }
    }

    private func setupExtraConfiguration() {
        backgroundColor = .white
        contentView.backgroundColor = .clear
    }
}
