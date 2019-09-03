import Quick
import Nimble

import CoreNavigation

class TestPresentViewControllerEvents: QuickSpec {
    private class MockViewController: UIViewController {}
    
    let canvas = Utilities.TestingCanvas()
    private let viewController = MockViewController()
    
    override func spec() {
        describe("When presenting") {
            context("UIViewController instance", {
                var viewDidLoad = false
                var viewWillAppear = false
                var viewDidAppear = false
                
                Present { $0
                    .to(self.viewController, from: self.canvas.rootViewController)
                    .onViewControllerEvents { $0
                        .viewDidLoad { _ in viewDidLoad = true }
                        .viewWillAppear { _, _ in viewWillAppear = true }
                        .viewDidAppear { _, _ in viewDidAppear = true }
                    }
                }
                
                it("is presented", closure: {
                    expect(self.viewController.isViewLoaded).toEventually(beTrue())
                })
                
                it("viewDidLoad was catched", closure: {
                    expect(viewDidLoad).toEventually(beTrue())
                })
                
                it("viewWillAppear was catched", closure: {
                    expect(viewWillAppear).toEventually(beTrue())
                })
                
                it("viewDidAppear was catched", closure: {
                    expect(viewDidAppear).toEventually(beTrue())
                })
            })
        }
    }
}
