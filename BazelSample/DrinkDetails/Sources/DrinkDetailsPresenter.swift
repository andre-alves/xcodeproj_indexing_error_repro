import DrinkDomain
import DrinkDetailsInterface
import UIKit

public final class DrinkDetailsPresenter: DrinkDetailsPresentationLogic {
    private weak var displayLogic: DrinkDetailsDisplayLogic?
    
    public init() {}

    public func setDisplayLogic(_ displayLogic: DrinkDetailsDisplayLogic?) {
        self.displayLogic = displayLogic
    }

    public func presentDrinkDetails(response: DrinkDetailsScene.DrinkDetails.Response) {
        displayLogic?.displayDrinkDetails(
            viewModel: .init(
                drink: .init(
                    id: response.drink.id,
                    name: response.drink.name,
                    imageURL: response.drink.previewImageURL,
                    instructions: response.drink.instruction,
                    ingredients: mergedIngredientsText(response.drink.ingredients)
                )
            )
        )
    }

    private func mergedIngredientsText(_ ingredients: [Ingredient]) -> String {
        ingredients.map { String(format: "%@ %@", $0.amount, $0.name) }.joined(separator: "\n")
    }
}
