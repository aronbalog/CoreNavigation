import Quick
import Nimble

import CoreNavigation

class TestPresentRoute: QuickSpec {
    final class MockDestination: Destination, DataReceivable, Routable {
        var parameters: [String: Any]?
        
        static func routePatterns() -> [String] {
            return ["TestPresentRoute/:parameter1"]
        }
        
        init(parameters: [String : Any]?) {
            self.parameters = parameters
        }
        
        typealias ViewControllerType = MockViewController
        typealias DataType = String
        
        var receivedData: String?
        
        func didReceiveData(_ data: String) {
            self.receivedData = data
        }
        
    }
    
    class MockViewController: UIViewController, DataReceivable {
        typealias DataType = String
        
        var receivedData: String?
        
        func didReceiveData(_ data: String) {
            self.receivedData = data
        }
    }
    
    let canvas = Utilities.TestingCanvas()
    
    override func spec() {
        describe("When presenting") {
            context("UIViewController instance via route", {
                Register(MockDestination.self)

                let route = "TestPresentRoute/one?parameter2=two"
                var mockDestination: MockDestination?
                var mockViewController: MockViewController?
                
                let passingData = "MockData"
                
                Present { $0
                    .to(route, from: self.canvas.rootViewController)
                    .passData(passingData)
                    .embed(inside: .tabBarController(UITabBarController.self, { .none }))
                    .onComplete({ (result) in
                        print("Completed")
                        mockDestination = result.destination.resolvedDestination as? MockDestination
                        mockViewController = result.toViewController as? MockViewController
                    })
                }
                
                it("is presented", closure: {
                    expect(mockViewController?.isViewLoaded).toEventually(beTrue())
                })
                
                it("destination received expected parameters", closure: {
                    let expectedParameters: NSDictionary = [
                        "parameter1": "one",
                        "parameter2": "two"
                    ]
                    expect(mockDestination?.parameters as NSDictionary?).toEventually(equal(expectedParameters))
                })
                
                it("destination received data", closure: {
                    expect(mockDestination?.receivedData).toEventually(equal(passingData))
                })
                
                it("view controller received data", closure: {
                    expect(mockViewController?.receivedData).toEventually(equal(passingData))
                })
            })
        }
    }
}
