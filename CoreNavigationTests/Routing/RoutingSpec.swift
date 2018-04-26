import UIKit
import Quick
import Nimble

@testable import CoreNavigation

fileprivate class MockViewController: UIViewController, DataReceivable {
    var data: String?
    var routeParameters: [String: Any]?
    
    func didReceiveData(_ data: String) {
       self.data = data
    }
    
    typealias DataType = String
}

fileprivate struct MockRoute: Destination, Routable {
    typealias ViewControllerType = MockViewController
    
    static var patterns: [String] = [
        "1/:firstName([a-zA-Z]+).*/:lastName(.*)",
        "1/:firstName(.*)/:lastName(.*)"
    ]
    
    static func resolve(context: Context<MockRoute>) {
        let viewController = MockViewController()
        viewController.routeParameters = context.parameters
        
        let data = context.parameters?["firstName"] as? String
        
        context.complete(viewController: viewController, data: data)
    }
}

fileprivate struct MockRoute2: Destination, Routable {
    typealias ViewControllerType = MockViewController
    
    static var patterns: [String] = [
        "2/:firstName([a-zA-Z]+).*/:lastName(.*)",
        "2/:firstName(.*)/:lastName(.*)"
    ]
}

fileprivate struct MockRoute3: Destination, Routable {
    typealias ViewControllerType = MockViewController
    
    static var patterns: [String] = [
        "3/:firstName([a-zA-Z]+).*/:lastName(.*)",
        "3/:firstName(.*)/:lastName(.*)"
    ]
    
    static func resolve(context: Context<MockRoute3>) {
        context.complete(data: context.parameters?["firstName"] as? String)
    }
}

class RoutingSpec: QuickSpec {
    override func spec() {
        describe("Routing") {
            Navigation.router.register(MockRoute.self)
            Navigation.router.register(MockRoute2.self)
            Navigation.router.register(MockRoute3.self)

            context("when routing to registered route", {
                var viewController: MockViewController?
                
                UIViewController.resolve("1/john/doe", { (_viewController: UIViewController) in
                    viewController = _viewController as? MockViewController
                }, failure: nil)
                
                it("it routes successfully", closure: {
                    expect(viewController).notTo(beNil())
                    expect(viewController?.routeParameters as NSDictionary?).to(equal([
                        "firstName": "john",
                        "lastName": "doe",
                        ]))
                })
            })
            
            context("when routing to registered route", {
                var viewController: MockViewController?
                
                UIViewController.resolve("1/john-middle-name/doe?query=param", { (_viewController: UIViewController) in
                    viewController = _viewController as? MockViewController
                }, failure: nil)
                
                it("it routes successfully", closure: {
                    expect(viewController).notTo(beNil())
                    expect(viewController?.routeParameters as NSDictionary?).to(equal([
                        "firstName": "john",
                        "lastName": "doe",
                        "query": "param"
                        ]))
                })
            })
            
            context("when routing to registered route", {
                var viewController: MockViewController?
                
                MockRoute().viewController({ (_viewController) in
                    viewController = _viewController
                })
                
                it("it routes successfully", closure: {
                    expect(viewController).toEventuallyNot(beNil())
                    expect(viewController?.routeParameters).toEventually(beNil())
                })
            })
            
            context("when routing to registered route", {
                let mockWindow = MockWindow()
                
                Navigation.present { $0
                    .to("2/john-middle-name/doe?query=param")
                    .passData("data")
                    .inWindow(mockWindow)
                }
                
                it("it routes successfully", closure: {
                    expect(mockWindow.rootViewController?.presentedViewController).toEventuallyNot(beNil())
                    expect((mockWindow.rootViewController?.presentedViewController as? MockViewController)?.data).toEventually(equal("data"))
                })
            })
            
            context("when routing to registered route", {
                var viewController: MockViewController?

                "3/john-middle-name/doe?query=param".viewController({ (_viewController) in
                    viewController = _viewController
                })
                
                it("it routes successfully", closure: {
                    expect(viewController).toEventuallyNot(beNil())
                    expect(viewController?.data).toEventually(equal("john"))
                })
            })
        }
    }
}



