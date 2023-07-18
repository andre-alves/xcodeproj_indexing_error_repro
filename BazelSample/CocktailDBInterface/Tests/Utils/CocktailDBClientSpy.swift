import CocktailDBInterface
import Foundation

public final class CocktailDBClientSpy: CocktailDBClient {
    public init() {}
    
    public func filterDrinks(completion: @escaping (Result<FilterResponse, Error>) -> Void) {}

    public func lookupDrink(id: String, completion: @escaping (Result<LookupResponse, Error>) -> Void) {}
}
