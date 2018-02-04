import UIKit
import Quick
import Nimble
import UIKit

@testable import CoreNavigation



extension NavigationTest {
    fileprivate class DestinationViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            
        }
    }
    fileprivate class MethodInvocationCounter {
        let viewControllerEvents = ViewControllerEvents()
        
        class ViewControllerEvents {
            var onViewLoad: Int = 0
            var onViewDidLoad: Int = 0
            var onViewWillAppear: Int = 0
            var onViewDidAppear: Int = 0
        }
    }
    class Present: QuickSpec {
        fileprivate lazy var methodInvocationCounter = MethodInvocationCounter()

        override func spec() {
            describe("navigation") {
                let delegate = UIApplication.shared.delegate
                
                let rootViewController = UIViewController()
                delegate?.window??.rootViewController = rootViewController

                context("when presented", {
                    var response: Response<UIViewController, DestinationViewController, UINavigationController>?
                    
                    CoreNavigation.Navigation.present({ (present) in
                        present
//                            .from(self.originVC)
                            .to(DestinationViewController.self)
                            .embed(in: UINavigationController.self)
                            .onSuccess({ (_response) in
                                response = _response
                            })
                            .onFailure({ (error) in
                                
                            })
                            .viewControllerEvents({ (events, viewController) in
                                events
                                    .loadView {
                                        self.methodInvocationCounter.viewControllerEvents.onViewLoad.increment()
                                    }
                                    .viewDidLoad {
                                        self.methodInvocationCounter.viewControllerEvents.onViewDidLoad.increment()
                                    }
                                    .viewWillAppear({ (animated) in
                                        self.methodInvocationCounter.viewControllerEvents.onViewWillAppear.increment()
                                    })
                                    .viewDidAppear({ (animated) in
                                        self.methodInvocationCounter.viewControllerEvents.onViewDidAppear.increment()
                                    })
                            })
                    })
                    
                    it("returns response in success block", closure: {
                        expect(response).toEventuallyNot(beNil())
                        expect(response?.embeddingViewController).toEventually(beAKindOf(UINavigationController.self))
                        expect(self.methodInvocationCounter.viewControllerEvents.onViewLoad).toEventually(equal(1))
                        expect(self.methodInvocationCounter.viewControllerEvents.onViewWillAppear).toEventually(equal(1))
                        expect(self.methodInvocationCounter.viewControllerEvents.onViewDidAppear).toEventually(equal(1))
                    })
                })
            }
        }
    }
}

fileprivate extension Int {
    mutating func increment() {
        self = self + 1
    }
}
