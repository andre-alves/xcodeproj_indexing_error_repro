import Foundation
import NetworkInterface
import XCTest

@testable import CocktailDB

final class CocktailDBTests: XCTestCase {
    private lazy var networkSpy = NetworkSpy()
    private lazy var sut = CocktailDB(apiKey: "test", network: networkSpy)

    func test_filterDrinks_shouldExecuteCorrectURL() {
        sut.filterDrinks { _ in }
        
        let urlExecuted = networkSpy.executeRequestPassed?.url?.absoluteString
        let urlExpected = "https://www.thecocktaildb.com/api/json/v1/test/filter.php?a=Alcoholic"
        XCTAssertEqual(urlExecuted, urlExpected)
    }
    
    func test_lookupDrink_shouldExecuteCorrectURL() {
        sut.lookupDrink(id: "test") { _ in }
        
        let urlExecuted = networkSpy.executeRequestPassed?.url?.absoluteString
        let urlExpected = "https://www.thecocktaildb.com/api/json/v1/test/lookup.php?i=test"
        XCTAssertEqual(urlExecuted, urlExpected)
    }
}

final class NetworkSpy: Networking {
    private(set) var executeRequestPassed: URLRequest?
    
    func execute<T>(request: URLRequest, responseSerializer: T, completion: @escaping (NetworkInterface.NetworkResponse<T.SerializedObject>) -> Void) where T: NetworkInterface.NetworkResponseSerializing {
        executeRequestPassed = request
    }
}
