import Quick
import Nimble

import CoreNavigation

class TestPresentEmbeddedViewController2: QuickSpec {
    private class MockViewController: UIViewController {}
    
    let canvas = Utilities.TestingCanvas()
    private let viewController = MockViewController()
    
    override func spec() {
        describe("When presenting") {
            context("UIViewController instance", {
                Present { $0
                    .to(self.viewController, from: self.canvas.rootViewController)
                    .embed({ (context) in
                        context.complete(viewController: UINavigationController(rootViewController: context.rootViewController))
                    })
                }
                
                it("is presented", closure: {
                    expect(self.viewController.isViewLoaded).toEventually(beTrue())
                })
                
                it("view controller is wrapped in navigation controller", closure: {
                    expect(self.viewController.navigationController).toEventuallyNot(beNil())
                })
            })
        }
    }
}
