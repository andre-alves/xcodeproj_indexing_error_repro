import Foundation

public struct GetAlcoholDrinkPreviews: GetAlcoholDrinkPreviewsUseCase {
    private let repository: CocktailRepositoryProtocol

    public init(repository: CocktailRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(completion: @escaping (Result<[DrinkPreview], Error>) -> Void) {
        repository.getPreviews(completion: completion)
    }
}
