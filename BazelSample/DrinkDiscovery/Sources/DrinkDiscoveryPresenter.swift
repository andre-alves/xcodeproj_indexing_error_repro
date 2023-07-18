import DrinkDiscoveryInterface
import UIKit

public final class DrinkDiscoveryPresenter: DrinkDiscoveryPresentationLogic {
    private weak var displayLogic: DrinkDiscoveryDisplayLogic?
    
    public init() {}

    public func setDisplayLogic(_ displayLogic: DrinkDiscoveryDisplayLogic?) {
        self.displayLogic = displayLogic
    }

    public func presentDrinkList(response: DrinkDiscoveryScene.DrinkList.Response) {
        switch response {
        case .success(let successResponse):
            displayLogic?.displayDrinkList(
                viewModel: .init(
                    previews: successResponse.previews.map { preview in
                        .init(
                            id: preview.id,
                            name: preview.name,
                            imageURL: preview.previewImageURL
                        )
                    }
                )
            )
        case .failure:
            displayLogic?.displayDrinkListError()
        }
    }
}
