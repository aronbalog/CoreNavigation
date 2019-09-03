import Quick
import Nimble

import CoreNavigation

class TestRouteViewController2: QuickSpec {
    final class MockViewController: UIViewController, Routable {
        static func routePatterns() -> [String] {
            return ["TestRouteViewController2/:parameter1/:parameter2"]
        }
        
        required init(parameters: [String : Any]?) {
            self.parameters = parameters
            super.init(nibName: nil, bundle: nil)
        }
        
        let parameters: [String: Any]?
        
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
    }
    
    override func spec() {
        describe("When resolving UIViewController from") {
            context("route", {
                Register(MockViewController.self)
                
                let viewController = try? "TestRouteViewController2/one/two?parameter3=three".viewController() as? MockViewController
                
                it("resolved view controller", closure: {
                    expect(viewController).toEventuallyNot(beNil())
                })
                
                it("extracted parameters", closure: {
                    let expectedParameters: NSDictionary = [
                        "parameter1": "one",
                        "parameter2": "two",
                        "parameter3": "three"
                    ]
                    
                    expect(viewController?.parameters as NSDictionary?).toEventually(equal(expectedParameters))
                })
            })
        }
    }
}
