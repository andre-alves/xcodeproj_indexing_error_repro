import Foundation

public protocol GetAlcoholDrinkPreviewsUseCase {
    func execute(completion: @escaping (Result<[DrinkPreview], Error>) -> Void)
}

public protocol GetDrinkUseCase {
    func execute(drinkId: String, completion: @escaping (Result<Drink, Error>) -> Void)
}
