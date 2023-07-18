import DrinkDomain
import UIKit

public protocol DrinkDiscoveryDisplayLogic: UIViewController {
    var interactor: DrinkDiscoveryBusinessLogic { get }

    func displayDrinkList(viewModel: DrinkDiscoveryScene.DrinkList.ViewModel)
    func displayDrinkListError()
}

public protocol DrinkDiscoveryBusinessLogic: AnyObject {
    var presenter: DrinkDiscoveryPresentationLogic { get }
    var router: DrinkDiscoveryRoutingLogic { get }

    func getDrinkList(request: DrinkDiscoveryScene.DrinkList.Request)
    func openDrink(request: DrinkDiscoveryScene.OpenDrink.Request)
}

public protocol DrinkDiscoveryPresentationLogic: AnyObject {
    func setDisplayLogic(_ displayLogic: DrinkDiscoveryDisplayLogic?)
    func presentDrinkList(response: DrinkDiscoveryScene.DrinkList.Response)
}

public protocol DrinkDiscoveryRoutingLogic: AnyObject {
    func setViewController(_ viewController: UIViewController?)
    func routeToDrinkDetails(drinkId: String)
}

public enum DrinkDiscoveryScene {
    public enum DrinkList {
        public struct Request {
            public init() {}
        }

        @frozen public enum Response {
            case success(SuccessResponse)
            case failure(Error)
        }
        
        public struct SuccessResponse {
            public let previews: [DrinkPreview]

            public init(previews: [DrinkPreview]) {
                self.previews = previews
            }
        }

        public struct ViewModel {
            public let previews: [DrinkPreviewViewModel]

            public init(previews: [DrinkPreviewViewModel]) {
                self.previews = previews
            }

            public struct DrinkPreviewViewModel {
                public let id: String
                public let name: String
                public let imageURL: URL

                public init(id: String, name: String, imageURL: URL) {
                    self.id = id
                    self.name = name
                    self.imageURL = imageURL
                }
            }
        }
    }

    public enum OpenDrink {
        public struct Request {
            public let drinkId: String

            public init(drinkId: String) {
                self.drinkId = drinkId
            }
        }
    }
}
