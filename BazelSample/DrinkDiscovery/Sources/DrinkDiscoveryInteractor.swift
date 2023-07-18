import DrinkDomain
import DrinkDiscoveryInterface
import UIKit

public final class DrinkDiscoveryInteractor: DrinkDiscoveryBusinessLogic {
    public let presenter: DrinkDiscoveryPresentationLogic
    public let router: DrinkDiscoveryRoutingLogic
    let getAlcholDrinksPreview: GetAlcoholDrinkPreviewsUseCase

    public init(
        presenter: DrinkDiscoveryPresentationLogic,
        router: DrinkDiscoveryRoutingLogic,
        getAlcholDrinksPreview: GetAlcoholDrinkPreviewsUseCase
    ) {
        self.presenter = presenter
        self.router = router
        self.getAlcholDrinksPreview = getAlcholDrinksPreview
    }

    public func getDrinkList(request: DrinkDiscoveryScene.DrinkList.Request) {
        getAlcholDrinksPreview.execute { [weak self] result in
            switch result {
            case .success(let previews):
                self?.presenter.presentDrinkList(response: .success(.init(previews: previews)))
            case .failure(let error):
                self?.presenter.presentDrinkList(response: .failure(error))
            }
        }
    }

    public func openDrink(request: DrinkDiscoveryScene.OpenDrink.Request) {
        router.routeToDrinkDetails(drinkId: request.drinkId)
    }
}
