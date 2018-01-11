import Foundation

import UIKit
import Quick
import Nimble

@testable import CoreNavigation

extension NavigationTest {
    fileprivate class OriginViewController: UIViewController {}
    fileprivate class DestinationViewController: UIViewController {}
    
    class Protection: QuickSpec {
        fileprivate lazy var originVC = NavigationTest.OriginViewController()
        fileprivate lazy var destinationVC = NavigationTest.DestinationViewController()
        fileprivate lazy var protection = MockProtection()
        
        override func spec() {
            describe("navigation") {
                let delegate = UIApplication.shared.delegate
                delegate?.window??.rootViewController = UIViewController()
                
                context("when navigating with protection", {
                    var response: Response<UIViewController, DestinationViewController, UIViewController>?
                    
                    CoreNavigation.Navigation.present({ (present) in
                        present
                            .from(self.originVC)
                            .to(self.destinationVC)
                            .protect(with: self.protection)
                            .onSuccess({ (_response) in
                                response = _response
                            })
                    })
                    
                    it("does not return response when protected", closure: {
                        expect(response).toEventually(beNil())
                    })
                    
                    it("does return response when unprotected", closure: {
                        self.protection.protected = false
                        self.protection.unprotectBlock?()
                        
                        expect(response).toEventuallyNot(beNil())
                    })
                })
            }
        }
    }
}

fileprivate class MockProtection: ProtectionSpace {
    var protected: Bool = true
    var unprotectBlock: (() -> Void)?
    
    func shouldProtect(unprotect: @escaping () -> Void, failure: @escaping (Error) -> Void) -> Bool {
        self.unprotectBlock = unprotect
        Navigation.present { (present) in
            present
                .to(ViewController.Green.self)
                .onSuccess({ (response) in
                    let vc = response.toViewController
                    vc?.dismiss(animated: true, completion: {
                        
                    })
                })
        }
        return protected
    }
}



