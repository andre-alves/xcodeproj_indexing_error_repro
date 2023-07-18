import CocktailDBInterface
import CocktailDB
import DrinkDomain
import DrinkDiscoveryInterface
import DrinkDiscovery
import DrinkDetailsInterface
import DrinkDetails
import DrinkData
import NetworkInterface
import Networking
import UIKit

/// [Root]

extension AppDelegate {
    func makeRootViewController() -> RootViewController {
        RootViewController(
            drinkDiscoveryDisplayLogic: makeDiscoveryDisplayLogic()
        )
    }
}

/// [Services]

extension AppDelegate {
    func makeCocktailDBClient() -> CocktailDBClient {
        CocktailDB(
            apiKey: "1",
            network: makeNetworking()
        )
    }

    func makeNetworking() -> Networking {
        Network(urlSession: .shared)
    }
}

/// [Domain & Data]

extension AppDelegate {
    func makeGetAlcoholDrinkPreviews() -> GetAlcoholDrinkPreviewsUseCase {
        GetAlcoholDrinkPreviews(repository: makeCocktailRepository())
    }
    
    func makeGetDrinkUseCase() -> GetDrinkUseCase {
        GetDrink(repository: makeCocktailRepository())
    }

    func makeCocktailRepository() -> CocktailRepositoryProtocol {
        CocktailRepository(api: makeCocktailDBClient())
    }
}

/// [Features]

/// [DrinkDiscovery]

extension AppDelegate {
    func makeDiscoveryDisplayLogic() -> DrinkDiscoveryDisplayLogic {
        DrinkDiscoveryViewController(
            interactor: DrinkDiscoveryInteractor(
                presenter: DrinkDiscoveryPresenter(),
                router: DrinkDiscoveryRouter(drinkDetailsDisplayLogicFactory: makeDrinkDetailsViewControllerFactory()),
                getAlcholDrinksPreview: makeGetAlcoholDrinkPreviews()
            ),
            view: DrinkDiscoveryView()
        )
    }
}

/// [DrinkDetails]

extension AppDelegate {
    func makeDrinkDetailsViewControllerFactory() -> DrinkDetailsViewControllerFactory {
        DrinkDetailsViewControllerFactory(
            businessLogic: makeDrinkDetailsBusinessLogic,
            view: makeDrinkDetailsView
        )
    }
    
    func makeDrinkDetailsBusinessLogic() -> DrinkDetailsBusinessLogic {
        DrinkDetailsInteractor(
            presenter: DrinkDetailsPresenter(),
            router: DrinkDetailsRouter(),
            getDrink: makeGetDrinkUseCase()
        )
    }
    
    func makeDrinkDetailsView() -> DrinkDetailsViewProtocol {
        DrinkDetailsView()
    }
}
