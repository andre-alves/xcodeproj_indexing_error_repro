import DrinkDiscoveryInterface
import UIKit

final class RootViewController: UINavigationController {

    init(drinkDiscoveryDisplayLogic: DrinkDiscoveryDisplayLogic) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [drinkDiscoveryDisplayLogic]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
