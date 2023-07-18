import CocktailDBInterface
import Foundation
import NetworkInterface

/// https://www.thecocktaildb.com/api.php
public final class CocktailDB: CocktailDBClient {
    private let apiKey: String
    private let network: Networking

    public init(apiKey: String, network: Networking) {
        self.apiKey = apiKey
        self.network = network
    }

    public func filterDrinks(completion: @escaping (Result<FilterResponse, Error>) -> Void) {
        let request = urlRequestFor(path: "filter.php?a=Alcoholic")
        let serializer = DecodableResponseSerializer<FilterResponse>(decoder: .init())
        network.execute(request: request, responseSerializer: serializer) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    public func lookupDrink(id: String, completion: @escaping (Result<LookupResponse, Error>) -> Void) {
        let request = urlRequestFor(path: "lookup.php?i=\(id)")
        let serializer = DecodableResponseSerializer<LookupResponse>(decoder: .init())
        network.execute(request: request, responseSerializer: serializer) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func urlRequestFor(path: String) -> URLRequest {
        //swiftlint:disable force_unwrapping
        URLRequest(url: URL(string: baseURL() + path)!)
    }

    private func baseURL() -> String {
        "https://www.thecocktaildb.com/api/json/v1/\(apiKey)/"
    }
}
