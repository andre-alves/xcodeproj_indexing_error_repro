import XCTest

@testable import DrinkDomain

final class GetDrinkTests: XCTestCase {
    private lazy var repositorySpy = CocktailRepositorySpy()
    private lazy var sut = GetDrink(repository: repositorySpy)

    func test_execute_shouldGetDrinkFromRepository() {
        let drink = DrinkDomain.Drink(
            id: "test",
            name: "test",
            previewImageURL: URL(fileURLWithPath: ""),
            instruction: "test",
            ingredients: []
        )
        repositorySpy.getDrinkToReturn = Result.success(drink)
        
        let expectation = self.expectation(description: "execute getDrink")
        sut.execute(drinkId: "123") { result in
            let drinkId = try? result.get().id
            XCTAssertEqual(drink.id, drinkId)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_execute_somethingSomethingSomethingSuccess() {
        XCTAssertTrue(true)
    }
    
    // Remove comments to run failing tests
    //func test_execute_somethingSomethingSomethingFailure() {
        //XCTAssertTrue(false)
    //}
}
