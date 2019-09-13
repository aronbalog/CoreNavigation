import Quick
import Nimble

import CoreNavigation

class TestRouteRegistration: QuickSpec {
    final class MockDestination: Destination, Routable {
        typealias ViewControllerType = UIViewController
        
        static func routePatterns() -> [String] {
            return ["TestRouteViewController/:parameter1"]
        }
        
        var parameters: [String : Any]?
        
        init(parameters: [String : Any]?) {
            self.parameters = parameters
        }
    }
    
    override func spec() {
        describe("Destination") {
            context("when registered", {
                Register(MockDestination.self)
                var resolvedDestination: MockDestination?
                var resolvedError: Error?
                
                "TestRouteViewController/one?parameter2=two".destination({ (destination) in
                    resolvedDestination = destination
                }, failure: { (error) in
                    resolvedError = error
                })
                
                it("is resolved", closure: {
                    expect(resolvedDestination).toEventuallyNot(beNil())
                    expect(resolvedError).toEventually(beNil())
                })
                
                it("extracted parameters", closure: {
                    let expectedParameters: NSDictionary = [
                        "parameter1": "one",
                        "parameter2": "two",
                    ]
                    
                    expect(resolvedDestination?.parameters as NSDictionary?).toEventually(equal(expectedParameters))
                })
            })
            
            context("when unregistered", {
                Unregister(MockDestination.self)
                let destination: MockDestination? = try? "TestRouteViewController/one?parameter2=two".destination()
                
                it("is not resolved", closure: {
                    expect(destination).toEventually(beNil())
                })
            })
        }
    }
}
