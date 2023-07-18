import UIKit
import Cartography
import CommonUI

public protocol DrinkDiscoveryViewProtocol: UIView, StatefulView {
    func setTableViewDataSource(_ dataSource: UITableViewDataSource)
    func setTableViewDelegate(_ delegate: UITableViewDelegate)
    func reloadTableView()
}

public final class DrinkDiscoveryView: UIView, DrinkDiscoveryViewProtocol {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DrinkDiscoveryTableViewCell.self, forCellReuseIdentifier: String(describing: DrinkDiscoveryTableViewCell.self))
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .clear
        return tableView
    }()

    public var currentState: State?
    public lazy var stateView: UIView? = self

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

    public func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }

    public func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

    public func reloadTableView() {
        tableView.reloadData()
    }
    
    private func setupComponents() {
        addSubview(tableView)
    }

    private func setupConstraints() {
        constrain(tableView, self) { tableView, superview in
            tableView.edges == superview.edges
        }
    }

    private func setupExtraConfiguration() {
        backgroundColor = .white
    }
}

extension DrinkDiscoveryView: StatefulView {
    public func adapt(toState state: State, animated: Bool) {}
}
