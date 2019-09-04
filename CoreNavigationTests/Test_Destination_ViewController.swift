import Quick
import Nimble

import CoreNavigation

private struct MockDestination: Destination {
    typealias ViewControllerType = UIViewController
}

class TestDestinationViewController: QuickSpec {
    override func spec() {
        describe("When resolving UIViewController from") {
            context("Destination instance", {
                let viewController = try? UIViewController.from(destination: MockDestination())
                
                it("is resolved", closure: {
                    expect(viewController).toEventuallyNot(beNil())
                })
            })
        }
    }
}