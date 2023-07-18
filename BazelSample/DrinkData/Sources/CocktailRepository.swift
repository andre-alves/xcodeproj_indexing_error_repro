import DrinkDomain
import CocktailDBInterface
import Foundation

public struct CocktailRepository: CocktailRepositoryProtocol {
    private let api: CocktailDBClient

    public init(api: CocktailDBClient) {
        self.api = api
    }

    public func getPreviews(completion: @escaping (Result<[DrinkPreview], Error>) -> Void) {
        api.filterDrinks { result in
            switch result {
            case .success(let response):
                let previews: [DrinkPreview] = response.drinks.map { drink in
                    .init(
                        id: drink.idDrink,
                        name: drink.strDrink,
                        //swiftlint:disable force_unwrapping
                        previewImageURL: URL(string: drink.strDrinkThumb)!.appendingPathComponent("preview")
                    )
                }
                completion(.success(previews))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func getDrink(id: String, completion: @escaping (Result<Drink, Error>) -> Void) {
        api.lookupDrink(id: id) { result in
            switch result {
            case .success(let response):
                let drink = getDrinkFromLookupResponse(response)
                completion(.success(drink))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getDrinkFromLookupResponse(_ response: LookupResponse) -> Drink {
        let drinkResponse = response.drinks[0]

        let ingredients: [Ingredient] = [
            (drinkResponse.strIngredient1, drinkResponse.strMeasure1),
            (drinkResponse.strIngredient2, drinkResponse.strMeasure2),
            (drinkResponse.strIngredient3, drinkResponse.strMeasure3),
            (drinkResponse.strIngredient4, drinkResponse.strMeasure4),
            (drinkResponse.strIngredient5, drinkResponse.strMeasure5),
            (drinkResponse.strIngredient6, drinkResponse.strMeasure6)
        ].compactMap { ingredient, measurement in
            guard let ingredient = ingredient else { return nil }
            guard let measurement = measurement else { return nil }
            return Ingredient(name: ingredient, amount: measurement)
        }

        return Drink(
            id: drinkResponse.idDrink,
            name: drinkResponse.strDrink,
            //swiftlint:disable force_unwrapping
            previewImageURL: URL(string: drinkResponse.strDrinkThumb)!.appendingPathComponent("preview"),
            instruction: drinkResponse.strInstructions,
            ingredients: ingredients
        )
    }
}
