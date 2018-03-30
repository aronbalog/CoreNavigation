import UIKit
import Quick
import Nimble

@testable import CoreNavigation

class StateRestorationSpec: QuickSpec {
    override func spec() {
        describe("Navigation") {
            context("when presenting view controller with automatic state restoration", {
                let mockViewController = UIViewController()
                Navigation.present({ $0
                    .to(mockViewController)
                    .stateRestorable()
                    .unsafely()
                    .inWindow(MockWindow())
                })
                
                it("it has restoration data", closure: {
                    expect(mockViewController.restorationIdentifier).toEventuallyNot(beNil())
                    expect(mockViewController.restorationClass).toEventually(beAnInstanceOf(StateRestoration.Type.self))
                })
            })
            
            context("when presenting view controller with state restoration identifier", {
                let mockViewController = UIViewController()
                let identifier = "mock"
                
                Navigation.present({ $0
                    .to(mockViewController)
                    .stateRestorable(identifier: identifier)
                    .unsafely()
                    .inWindow(MockWindow())
                })
                
                it("it has restoration data", closure: {
                    expect(mockViewController.restorationIdentifier).toEventually(equal(identifier))
                    expect(mockViewController.restorationClass).toEventually(beAnInstanceOf(StateRestoration.Type.self))
                })
            })
            
            context("when presenting view controller with state restoration identifier and class", {
                class MockStateRestoration: UIViewControllerRestoration {
                    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
                        return nil
                    }
                }
                
                let mockViewController = UIViewController()
                let identifier = "mock"
                
                Navigation.present({ $0
                    .to(mockViewController)
                    .stateRestorable(identifier: identifier, class: MockStateRestoration.self)
                    .unsafely()
                    .inWindow(MockWindow())
                })
                
                it("it has restoration data", closure: {
                    expect(mockViewController.restorationIdentifier).toEventually(equal(identifier))
                    expect(mockViewController.restorationClass).toEventually(beAnInstanceOf(MockStateRestoration.Type.self))
                })
            })
        }
    }
}

