import XCTest

@testable import DrinkDomain

final class GetAlcoholDrinkPreviewsTests: XCTestCase {
    private lazy var repositorySpy = CocktailRepositorySpy()
    private lazy var sut = GetAlcoholDrinkPreviews(repository: repositorySpy)

    func test_execute_shouldGetPreviewsFromRepository() {
        let drink = DrinkDomain.DrinkPreview(
            id: "test",
            name: "test",
            previewImageURL: URL(fileURLWithPath: "")
        )
        repositorySpy.getPreviewsToReturn = Result.success([drink])
        
        let expectation = self.expectation(description: "execute getDrink")
        sut.execute { result in
            let drinkId = try? result.get().first?.id
            XCTAssertEqual(drink.id, drinkId)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_execute_somethingSomethingSomethingSuccess() {
        XCTAssertTrue(true)
    }
}
