import DrinkDomain
import UIKit

public protocol DrinkDetailsDisplayLogicFactory {
    func build(drinkId: String) -> DrinkDetailsDisplayLogic
}

public protocol DrinkDetailsDisplayLogic: UIViewController {
    var interactor: DrinkDetailsBusinessLogic { get }

    func displayDrinkDetails(viewModel: DrinkDetailsScene.DrinkDetails.ViewModel)
}

public protocol DrinkDetailsBusinessLogic: AnyObject {
    var presenter: DrinkDetailsPresentationLogic { get }
    var router: DrinkDetailsRoutingLogic { get }

    func getDrinkDetails(request: DrinkDetailsScene.DrinkDetails.Request)
}

public protocol DrinkDetailsPresentationLogic: AnyObject {
    func setDisplayLogic(_ displayLogic: DrinkDetailsDisplayLogic?)
    func presentDrinkDetails(response: DrinkDetailsScene.DrinkDetails.Response)
}

public protocol DrinkDetailsRoutingLogic: AnyObject {
    func setViewController(_ viewController: UIViewController?)
}

public enum DrinkDetailsScene {
    public enum DrinkDetails {
        public struct Request {
            public let drinkId: String

            public init(drinkId: String) {
                self.drinkId = drinkId
            }
        }

        public struct Response {
            public let drink: Drink

            public init(drink: Drink) {
                self.drink = drink
            }
        }

        public struct ViewModel {
            public let drink: DrinkViewModel

            public init(drink: DrinkViewModel) {
                self.drink = drink
            }

            public struct DrinkViewModel {
                public let id: String
                public let name: String
                public let imageURL: URL
                public let instructions: String
                public let ingredients: String

                public init(id: String, name: String, imageURL: URL, instructions: String, ingredients: String) {
                    self.id = id
                    self.name = name
                    self.imageURL = imageURL
                    self.instructions = instructions
                    self.ingredients = ingredients
                }
            }
        }
    }
}
