import Quick
import Nimble

import CoreNavigation

class TestRouteViewController: QuickSpec {
    final class MockDestination: Destination, Routable {
        typealias ViewControllerType = MockViewController
        
        static func routePatterns() -> [String] {
            ["TestRouteViewController/:parameter1"]
        }
        
        var parameters: [String : Any]?
        
        init(parameters: [String : Any]?) {
            self.parameters = parameters
        }
        
        func resolve(with resolver: Resolver<MockDestination>) {
            resolver.complete(viewController: MockViewController(parameters: parameters))
        }
    }
    
    class MockViewController: UIViewController {
        let parameters: [String: Any]?
        
        init(parameters: [String: Any]?) {
            self.parameters = parameters
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
    }
    
    override func spec() {
        describe("When resolving UIViewController from") {
            context("route", {
                Register(MockDestination.self)
                let viewController = try? UIViewController.from(matchable: "TestRouteViewController/one?parameter2=two") as? MockViewController
                
                it("resolved view controller", closure: {
                    expect(viewController).toEventuallyNot(beNil())
                })
                
                it("extracted parameters", closure: {
                    let expectedParameters: NSDictionary = [
                        "parameter1": "one",
                        "parameter2": "two",
                    ]

                    expect(viewController?.parameters as NSDictionary?).toEventually(equal(expectedParameters))
                })
                
                
            })
        }
    }
}
