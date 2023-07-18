import Foundation

public struct GetDrink: GetDrinkUseCase {
    private let repository: CocktailRepositoryProtocol

    public init(repository: CocktailRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(drinkId: String, completion: @escaping (Result<Drink, Error>) -> Void) {
        repository.getDrink(id: drinkId, completion: completion)
    }
}
