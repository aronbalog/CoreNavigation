import Quick
import Nimble

import CoreNavigation

private final class MockDestination: Destination, DataReceivable {
    typealias ViewControllerType = MockViewController
    typealias DataType = String
    
    var receivedData: String?
    
    func didReceiveData(_ data: String) {
        self.receivedData = data
    }
    
}

private class MockViewController: UIViewController, DataReceivable {
    typealias DataType = String
    
    var receivedData: String?
    
    func didReceiveData(_ data: String) {
        self.receivedData = data
    }
}

class TestPresentDestination: QuickSpec {
    let canvas = Utilities.TestingCanvas()
    
    override func spec() {
        describe("When presenting") {
            context("UIViewController instance via Destination", {
                let mockDestination = MockDestination()
                var mockViewController: MockViewController?
                
                let passingData = "MockData"
                
                Present { $0
                    .to(mockDestination, from: self.canvas.rootViewController)
                    .passData(passingData)
                    .onComplete({ (result) in
                        print("👿 Mocked!", result.toViewController)

                        mockViewController = result.toViewController
                    })

                }
                
                it("is presented", closure: {
                    expect(mockViewController?.isViewLoaded).toEventually(beTrue())
                })
                
                it("destination received data", closure: {
                    expect(mockDestination.receivedData).toEventually(equal(passingData))
                })
                
                it("view controller received data", closure: {
                    expect(mockViewController?.receivedData).toEventually(equal(passingData))
                })
            })
        }
    }
}
