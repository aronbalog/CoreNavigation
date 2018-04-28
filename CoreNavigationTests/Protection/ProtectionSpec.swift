import UIKit
import Quick
import Nimble

@testable import CoreNavigation

private class MockProtectionSpace: ProtectionSpace {
    var isProtected = true

    func protect(_ handler: ProtectionHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isProtected = false
            handler.unprotect()
        }
    }

    func shouldProtect() -> Bool {
        return isProtected
    }

}

class ProtectionSpec: QuickSpec {
    override func spec() {
        describe("Navigation") {
            context("when presenting protected view controller", {
                let mockProtectionSpace = MockProtectionSpace()
                var didNavigate = false

                Navigate.present { $0
                    .to(UIViewController())
                    .protect(with: mockProtectionSpace)
                    .completion {
                        didNavigate = true
                    }
                }

                it("", closure: {
                    expect(mockProtectionSpace.isProtected).toEventually(beFalse())
                    expect(didNavigate).toEventually(beTrue())
                })
            })
        }
    }
}
