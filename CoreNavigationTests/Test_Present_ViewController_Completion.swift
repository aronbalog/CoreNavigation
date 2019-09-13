import Quick
import Nimble

import CoreNavigation

class TestPresentViewControllerCompletion: QuickSpec {
    private class MockViewController: UIViewController {}
    
    let canvas = Utilities.TestingCanvas()
    private let viewController = MockViewController()
    
    override func spec() {
        describe("When presenting") {
            context("UIViewController instance", {
                var didComplete = false
                
                Present { $0
                    .to(self.viewController, from: self.canvas.rootViewController)
                    .onComplete({ (result) in
                        didComplete = true
                    })
                }
                
                it("is presented", closure: {
                    expect(self.viewController.isViewLoaded).toEventually(beTrue())
                })
                
                it("onComplete was invoked", closure: {
                    expect(didComplete).toEventually(beTrue())
                })
            })
        }
    }
}
