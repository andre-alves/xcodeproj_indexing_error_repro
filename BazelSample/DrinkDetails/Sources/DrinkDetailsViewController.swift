import DrinkDetailsInterface
import UIKit

final class DrinkDetailsViewController: UIViewController, DrinkDetailsDisplayLogic {
    let interactor: DrinkDetailsBusinessLogic
    let customView: DrinkDetailsViewProtocol

    private let drinkId: String

    init(drinkId: String, interactor: DrinkDetailsBusinessLogic, view: DrinkDetailsViewProtocol) {
        self.drinkId = drinkId
        self.interactor = interactor
        self.customView = view
        super.init(nibName: nil, bundle: nil)

        self.interactor.presenter.setDisplayLogic(self)
        self.interactor.router.setViewController(self)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        self.view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Localization.DrinkDetailsViewController.NavigationBar.loading
        navigationController?.setNavigationBarHidden(false, animated: true)

        customView.transition(toState: .loading, animated: true)
        interactor.getDrinkDetails(request: .init(drinkId: drinkId))
    }

    func displayDrinkDetails(viewModel: DrinkDetailsScene.DrinkDetails.ViewModel) {
        navigationItem.title = viewModel.drink.name
        customView.configure(with: viewModel)
        customView.transition(toState: .content, animated: true)
    }
}

public final class DrinkDetailsViewControllerFactory: DrinkDetailsDisplayLogicFactory {
    public typealias BusinessLogic = () -> DrinkDetailsBusinessLogic
    public typealias View = () -> DrinkDetailsViewProtocol
    
    private let businessLogic: BusinessLogic
    private let view: View
     
    public init(businessLogic: @escaping BusinessLogic, view: @escaping View) {
        self.businessLogic = businessLogic
        self.view = view
    }
    
    public func build(drinkId: String) -> DrinkDetailsInterface.DrinkDetailsDisplayLogic {
        DrinkDetailsViewController(
            drinkId: drinkId,
            interactor: businessLogic(),
            view: view()
        )
    }
}
