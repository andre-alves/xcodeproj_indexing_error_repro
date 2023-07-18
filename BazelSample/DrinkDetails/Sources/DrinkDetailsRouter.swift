import DrinkDetailsInterface
import UIKit

public final class DrinkDetailsRouter: DrinkDetailsRoutingLogic {
    private weak var viewController: UIViewController?

    public init() {}
    
    public func setViewController(_ viewController: UIViewController?) {
        self.viewController = viewController
    }
}
