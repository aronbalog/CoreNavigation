import Foundation

import UIKit
import Quick
import Nimble

@testable import CoreNavigation

extension NavigationTest {
    fileprivate class OriginViewController: UIViewController {}
    fileprivate class DestinationViewController: UIViewController {}
    
    class Push: QuickSpec {
        fileprivate lazy var navigationController = UINavigationController(rootViewController: self.originVC)
        fileprivate lazy var originVC = NavigationTest.OriginViewController()
        fileprivate lazy var destinationVC = NavigationTest.DestinationViewController()
        
        override func spec() {
            describe("navigation") {
                let delegate = UIApplication.shared.delegate
                delegate?.window??.rootViewController = navigationController
                
                context("when pushed", {
                    var response: Response<UIViewController, DestinationViewController, UIViewController>?
                    
                    CoreNavigation.Navigation.push({ (push) in
                        push
                            .from(self.originVC)
                            .to(self.destinationVC)
                            .onSuccess({ (_response) in
                                response = _response
                            })
                            .onFailure({ (error) in
                                
                            })
                    })
                    
                    it("returns response in success block", closure: {
                        expect(response).toEventuallyNot(beNil())
                        expect(response?.fromViewController).toEventually(be(self.originVC))
                        expect(response?.toViewController).toEventually(be(self.destinationVC))
                        
                        expect(response?.toViewController?.navigationController).toEventually(be(self.navigationController))
                        expect(response?.fromViewController?.navigationController).toEventually(be(self.navigationController))
                        
                        expect(response?.fromViewController?.navigationController?.visibleViewController).toEventually(be(self.destinationVC))
                        expect(response?.fromViewController?.navigationController?.viewControllers[0]).toEventually(be(self.originVC))
                    })
                })
            }
        }
    }
}

