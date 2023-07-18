import DrinkDomain
import DrinkDetailsInterface
import UIKit

public final class DrinkDetailsInteractor: DrinkDetailsBusinessLogic {
    public let presenter: DrinkDetailsPresentationLogic
    public let router: DrinkDetailsRoutingLogic
    let getDrink: GetDrinkUseCase

    public init(
        presenter: DrinkDetailsPresentationLogic,
        router: DrinkDetailsRoutingLogic,
        getDrink: GetDrinkUseCase
    ) {
        self.presenter = presenter
        self.router = router
        self.getDrink = getDrink
    }

    public func getDrinkDetails(request: DrinkDetailsScene.DrinkDetails.Request) {
        getDrink.execute(drinkId: request.drinkId) { [weak self] result in
            let drink = try! result.get()
            self?.presenter.presentDrinkDetails(response: .init(drink: drink))
        }
    }
}
