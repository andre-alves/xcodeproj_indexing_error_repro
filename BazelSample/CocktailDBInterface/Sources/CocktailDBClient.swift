import Foundation

public protocol CocktailDBClient {
    func filterDrinks(completion: @escaping (Result<FilterResponse, Error>) -> Void)
    func lookupDrink(id: String, completion: @escaping (Result<LookupResponse, Error>) -> Void)
}

public struct FilterResponse: Decodable {
    public let drinks: [CocktailPreview]
}

public struct CocktailPreview: Decodable {
    public let strDrink: String
    public let strDrinkThumb: String
    public let idDrink: String
}

public struct LookupResponse: Decodable {
    public let drinks: [Cocktail]
}

public struct Cocktail: Decodable {
    public let strDrink: String
    public let strDrinkThumb: String
    public let idDrink: String
    public let strCategory: String
    public let strInstructions: String

    public let strIngredient1: String?
    public let strIngredient2: String?
    public let strIngredient3: String?
    public let strIngredient4: String?
    public let strIngredient5: String?
    public let strIngredient6: String?

    public let strMeasure1: String?
    public let strMeasure2: String?
    public let strMeasure3: String?
    public let strMeasure4: String?
    public let strMeasure5: String?
    public let strMeasure6: String?
}
