import CommonUI
import DrinkDiscoveryInterface
import UIKit

public final class DrinkDiscoveryViewController: UIViewController, DrinkDiscoveryDisplayLogic {
    public let interactor: DrinkDiscoveryBusinessLogic
    let customView: DrinkDiscoveryViewProtocol

    private var drinks: [DrinkDiscoveryScene.DrinkList.ViewModel.DrinkPreviewViewModel] = []

    public init(interactor: DrinkDiscoveryBusinessLogic, view: DrinkDiscoveryViewProtocol) {
        self.interactor = interactor
        self.customView = view
        super.init(nibName: nil, bundle: nil)

        self.customView.setTableViewDelegate(self)
        self.customView.setTableViewDataSource(self)

        self.interactor.presenter.setDisplayLogic(self)
        self.interactor.router.setViewController(self)
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        self.view = customView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Drinks"
        navigationController?.setNavigationBarHidden(false, animated: true)
        loadDrinks()
    }

    public func displayDrinkList(viewModel: DrinkDiscoveryScene.DrinkList.ViewModel) {
        drinks = viewModel.previews
        customView.reloadTableView()
        customView.transition(toState: .content, animated: true)
    }
    
    public func displayDrinkListError() {
        let emptyState = EmptyState.with(error: nil, buttonDelegate: self)
        customView.transition(toState: .empty(emptyState), animated: true)
    }
    
    private func loadDrinks() {
        customView.transition(toState: .loading, animated: false)
        interactor.getDrinkList(request: .init())
    }
}

extension DrinkDiscoveryViewController: EmptyStateViewDelegate {
    public func emptyStateViewButtonTouched(forState emptyState: CommonUI.EmptyState) {
        loadDrinks()
    }
}

extension DrinkDiscoveryViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drink = drinks[indexPath.row]
        interactor.openDrink(request: .init(drinkId: drink.id))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DrinkDiscoveryViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinks.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: DrinkDiscoveryTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        guard let optionCell = cell as? DrinkDiscoveryTableViewCell else {
            return cell
        }

        let drink = drinks[indexPath.row]
        optionCell.configure(with: .init(title: drink.name, subtitle: drink.id, imageURL: drink.imageURL))
        return optionCell
    }
}
