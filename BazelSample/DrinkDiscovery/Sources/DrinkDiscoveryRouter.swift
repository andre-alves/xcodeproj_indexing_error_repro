import DrinkDiscoveryInterface
import DrinkDetailsInterface
import UIKit

public final class DrinkDiscoveryRouter: DrinkDiscoveryRoutingLogic {
    private let drinkDetailsDisplayLogicFactory: DrinkDetailsDisplayLogicFactory
    private weak var viewController: UIViewController?

    public init(drinkDetailsDisplayLogicFactory: DrinkDetailsDisplayLogicFactory) {
        self.drinkDetailsDisplayLogicFactory = drinkDetailsDisplayLogicFactory
    }

    public func setViewController(_ viewController: UIViewController?) {
        self.viewController = viewController
    }

    public func routeToDrinkDetails(drinkId: String) {
        let drinkDetailsDisplayLogic = drinkDetailsDisplayLogicFactory.build(drinkId: drinkId)
        viewController?.navigationController?.pushViewController(drinkDetailsDisplayLogic, animated: true)
    }
}
