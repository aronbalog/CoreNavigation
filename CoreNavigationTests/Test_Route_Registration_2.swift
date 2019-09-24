import Quick
import Nimble

import CoreNavigation

class TestRouteRegistration2: QuickSpec {
    final class MockDestination: Destination, Routable {
        typealias ViewControllerType = UIViewController
        
        static func routePatterns() -> [String] {
            ["TestRouteRegistration2/:parameter1"]
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
                var resolvedError: Error?
                
                "UnreachableRoute/one?parameter2=two".destination({ (destination: MockDestination) in
                    
                }, failure: { (error) in
                    resolvedError = error
                })
                
                it("resolved error", closure: {
                    expect(resolvedError).toEventuallyNot(beNil())
                })
                
            })
        }
    }
}
