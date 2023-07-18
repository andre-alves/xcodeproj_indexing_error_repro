import FBSnapshotTestCaseSwift
import FBSnapshotTestCase
import DrinkDiscoveryInterface
import UIKit
import XCTest

@testable import DrinkDiscovery

final class DrinkDiscoveryViewControllerTests: FBSnapshotTestCase {
    private lazy var interactor = DrinkDiscoveryBusinessLogicDummy()
    private lazy var sut = DrinkDiscoveryViewController(
        interactor: interactor,
        view: DrinkDiscoveryView()
    )

    func test_viewController_withDrinks() {
        adjustViewControllerSize(sut)
        
        withAnimationsDisabled {
            let viewModel = DrinkDiscoveryScene.DrinkList.ViewModel(
                previews: [
                    .init(id: "test_a", name: "Test Drink A", imageURL: URL(fileURLWithPath: "")),
                    .init(id: "test_b", name: "Test Drink B", imageURL: URL(fileURLWithPath: "")),
                    .init(id: "test_c", name: "Test Drink C", imageURL: URL(fileURLWithPath: "")),
                    .init(id: "test_d", name: "Test Drink D", imageURL: URL(fileURLWithPath: ""))
                ]
            )
            
            sut.displayDrinkList(viewModel: viewModel)
            assertSnapshot(view: sut.view)
        }
    }
    
    func test_viewController_withErrorEmptyState() {
        adjustViewControllerSize(sut)
        
        withAnimationsDisabled {
            sut.displayDrinkListError()
            assertSnapshot(view: sut.view)
        }
    }
    
    // Uncomment this test to fail the execution
//    func test_viewController_ToFail() {
//        adjustViewControllerSize(sut)
//
//        withAnimationsDisabled {
//            let viewModel = DrinkDiscoveryScene.DrinkList.ViewModel(
//                previews: [
//                    .init(id: "test_a", name: "Test Drink A", imageURL: URL(fileURLWithPath: "")),
//                    .init(id: "test_B", name: "Test Drink B", imageURL: URL(fileURLWithPath: ""))
//                ]
//            )
//
//            sut.displayDrinkList(viewModel: viewModel)
//            assertSnapshot(view: sut.view)
//        }
//    }
    
    private func adjustViewControllerSize(_ vc: UIViewController) {
        vc.view.frame = CGRect(x: 0, y: 0, width: 375, height: 812) // iPhone X, XS
    }
    
    private func withAnimationsDisabled(block: () -> Void) {
        UIView.setAnimationsEnabled(false)
        block()
        UIView.setAnimationsEnabled(true)
    }
    
    private func assertSnapshot(view: UIView) {
        recordMode = false
        //swiftlint:disable snapshot_test_pixel_tolerance
        FBSnapshotVerifyView(
            view,
            suffixes: FBSnapshotTestCaseDefaultSuffixes(),
            perPixelTolerance: 0.01,
            overallTolerance: 0
        )
    }
}

private final class DrinkDiscoveryBusinessLogicDummy: DrinkDiscoveryBusinessLogic {
    let presenter: DrinkDiscoveryPresentationLogic = DrinkDiscoveryPresentationLogicDummy()
    let router: DrinkDiscoveryRoutingLogic = DrinkDiscoveryRoutingLogicDummy()
    
    func openDrink(request: DrinkDiscoveryScene.OpenDrink.Request) {}
    func getDrinkList(request: DrinkDiscoveryScene.DrinkList.Request) {}
}

private final class DrinkDiscoveryPresentationLogicDummy: DrinkDiscoveryPresentationLogic {
    func setDisplayLogic(_ displayLogic: DrinkDiscoveryDisplayLogic?) {}
    func presentDrinkList(response: DrinkDiscoveryScene.DrinkList.Response) {}
}

private final class DrinkDiscoveryRoutingLogicDummy: DrinkDiscoveryRoutingLogic {
    func setViewController(_ viewController: UIViewController?) {}
    func routeToDrinkDetails(drinkId: String) {}
}
