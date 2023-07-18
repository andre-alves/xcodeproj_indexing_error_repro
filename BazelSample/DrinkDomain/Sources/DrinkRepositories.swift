import Foundation

public protocol CocktailRepositoryProtocol {
    func getPreviews(completion: @escaping (Result<[DrinkPreview], Error>) -> Void)
    func getDrink(id: String, completion: @escaping (Result<Drink, Error>) -> Void)
}
