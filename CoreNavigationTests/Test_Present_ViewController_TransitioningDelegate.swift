import Quick
import Nimble

import CoreNavigation

class TestPresentViewControllerTransitioningDelegate: QuickSpec {
    private class MockViewController: UIViewController {}
    
    let canvas = Utilities.TestingCanvas()
    private let viewController = MockViewController()
    
    override func spec() {
        describe("When presenting") {
            context("UIViewController instance", {
                var didTransition = false
                
                Present { $0
                    .to(self.viewController, from: self.canvas.rootViewController)
                    .transition(with: 0.3, { (context) in
                        didTransition = true
                    })
                }
                
                it("transition was invoked", closure: {
                    expect(didTransition).toEventually(beTrue())
                })
            })
        }
    }
}
