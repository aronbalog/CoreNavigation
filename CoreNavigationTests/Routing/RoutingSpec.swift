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

fileprivate struct MockRoute: Route, RoutePatternsAware {
    typealias Destination = MockViewController
    
    static var patterns: [String] = [
        "1/:firstName([a-zA-Z]+).*/:lastName(.*)",
        "1/:firstName(.*)/:lastName(.*)"
    ]
    
    static func route(handler: RouteHandler<MockRoute>) {
        let viewController = MockViewController()
        viewController.routeParameters = handler.parameters
        
        let data = handler.parameters?["firstName"] as? String
        
        handler.complete(viewController: viewController, data: data)
    }
}

fileprivate struct MockRoute2: Route, RoutePatternsAware {
    typealias Destination = MockViewController
    
    static var patterns: [String] = [
        "2/:firstName([a-zA-Z]+).*/:lastName(.*)",
        "2/:firstName(.*)/:lastName(.*)"
    ]
}

fileprivate struct MockRoute3: Route, RoutePatternsAware {
    typealias Destination = MockViewController
    
    static var patterns: [String] = [
        "3/:firstName([a-zA-Z]+).*/:lastName(.*)",
        "3/:firstName(.*)/:lastName(.*)"
    ]
    
    static func route(handler: RouteHandler<MockRoute3>) {
        handler.complete(data: handler.parameters?["firstName"] as? String)
    }
}

class RoutingSpec: QuickSpec {
    override func spec() {
        describe("Routing") {
            Navigation.router.registerRoute(MockRoute.self)
            Navigation.router.registerRoute(MockRoute2.self)
            Navigation.router.registerRoute(MockRoute3.self)

            context("when routing to registered route", {
                var viewController: MockViewController?
                
                UIViewController.route(to: "1/john/doe", { (_viewController) in
                    viewController = _viewController as? MockViewController
                })
                
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
                
                UIViewController.route(to: "1/john-middle-name/doe?query=param", { (_viewController) in
                    viewController = _viewController as? MockViewController
                })
                
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
                let mockApplication = MockApplication()
                
                Navigation.present { $0
                    .to("2/john-middle-name/doe?query=param")
                    .pass("data")
                    .in(application: mockApplication)
                }
                
                it("it routes successfully", closure: {
                    expect(mockApplication.window.rootViewController?.presentedViewController).toEventuallyNot(beNil())
                    expect((mockApplication.window.rootViewController?.presentedViewController as? MockViewController)?.data).toEventually(equal("data"))
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



