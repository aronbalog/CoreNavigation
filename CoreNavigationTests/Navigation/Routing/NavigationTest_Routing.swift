import Foundation
import Quick
import Nimble
import CoreRoute

@testable import CoreNavigation

struct MockRoute: AbstractRoute {
    var routePath: String = "mock-route"
}

extension NavigationTest {
    fileprivate class OriginViewController: UIViewController {}
    fileprivate class DestinationViewController: UIViewController {}
    
    class Routing: QuickSpec {
        fileprivate lazy var originVC = OriginViewController()

        override func spec() {
            describe("navigation") {
                let delegate = UIApplication.shared.delegate
                delegate?.window??.rootViewController = originVC
                
                Navigation.router.register(route: MockRoute(), destination: DestinationViewController.self)

                context("when presented", {
                    var response: CoreNavigation.Response<OriginViewController, UIViewController, UINavigationController>?

                    CoreNavigation.Navigation.present({ (present) in
                        present
                            .from(self.originVC)
                            .to(MockRoute())
                            .embed(in: UINavigationController.self)
                            .onSuccess({ (_response) in
                                response = _response
                            })
                            .onFailure({ (error) in
                                
                            })
                    })
                    
                    it("returns response in success block", closure: {
                        expect(response).toEventuallyNot(beNil(), timeout: 0.5, pollInterval: 0.1)
                        expect(response?.fromViewController).toEventually(be(self.originVC))
                        expect(response?.toViewController).toEventually(beAKindOf(UIViewController.self))
                    })
                })
            }
        }
    }
}
