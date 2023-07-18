import DrinkDomain

final class CocktailRepositorySpy: CocktailRepositoryProtocol {
    var getPreviewsToReturn: Result<[DrinkDomain.DrinkPreview], Error>?
    var getDrinkToReturn: Result<DrinkDomain.Drink, Error>?
    
    func getPreviews(completion: @escaping (Result<[DrinkDomain.DrinkPreview], Error>) -> Void) {
        if let result = getPreviewsToReturn {
            completion(result)
        }
    }
    
    func getDrink(id: String, completion: @escaping (Result<DrinkDomain.Drink, Error>) -> Void) {
        if let result = getDrinkToReturn {
            completion(result)
        }
    }
}
