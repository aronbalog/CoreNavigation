import Quick
import Nimble

import CoreNavigation

class TestPresentViewController: QuickSpec {
    private class MockViewController: UIViewController, DataReceivable {
        typealias DataType = String
        
        var receivedData: String?
        
        func didReceiveData(_ data: String) {
            receivedData = data
        }
    }
    
    let canvas = Utilities.TestingCanvas()
    private let viewController = MockViewController()
    let passingData = "mock-data"
   
    override func spec() {
        describe("When presenting") {
            context("UIViewController instance", {
                Present { $0
                    .to(self.viewController, from: self.canvas.rootViewController)
                    .passDataToViewController(self.passingData)
                }
                
                it("is presented", closure: {
                    expect(self.viewController.isViewLoaded).toEventually(beTrue())
                })
                
                it("view controller received data", closure: {
                    expect(self.viewController.receivedData).toEventually(equal(self.passingData))
                })
            })
        }
    }
}
