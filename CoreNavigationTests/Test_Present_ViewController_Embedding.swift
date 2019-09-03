import Quick
import Nimble

import CoreNavigation

class TestPresentEmbeddedViewController: QuickSpec {
    private class MockViewController: UIViewController {}
    
    let canvas = Utilities.TestingCanvas()
    private let viewController = MockViewController()
    
    override func spec() {
        describe("When presenting") {
            context("UIViewController instance", {
                Present { $0
                    .to(self.viewController, from: self.canvas.rootViewController)
                    .embed(with: .tabBarController(.navigationController(nil)))
                }
                
                it("is presented", closure: {
                    expect(self.viewController.isViewLoaded).toEventually(beTrue())
                })
                
                it("view controller is wrapped in navigation controller", closure: {
                    expect(self.viewController.navigationController).toEventuallyNot(beNil())
                })
                
                it("navigation controller is wrapped in tab bar controller", closure: {
                    expect(self.viewController.navigationController?.tabBarController).toEventuallyNot(beNil())
                })
            })
        }
    }
}
