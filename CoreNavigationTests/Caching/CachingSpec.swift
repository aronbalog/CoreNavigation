import UIKit
import Quick
import Nimble

@testable import CoreNavigation

private class UndyingLifetime: Lifetime {
    func die(_ kill: @escaping () -> Void) {
        // never dies
    }
}

private class DyingLifetime: Lifetime {
    func die(_ kill: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            kill()
        }
    }
}

private class DyingViewController: UIViewController {
    static var _viewDidLoad = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        DyingViewController._viewDidLoad.invoke()
    }
}

private class UndyingViewController: UIViewController {
    static var _viewDidLoad = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        UndyingViewController._viewDidLoad.invoke()
    }
}

class CachingSpec: QuickSpec {
    override func spec() {
        describe("Navigation") {
            context("when presenting view controller multiple times with caching", {
                let mockWindow = MockWindow()
                let mockViewController = UndyingViewController.self
                let cacheIdentifier = "undying"

                Navigate.present({ $0
                    .to(mockViewController)
                    .keepAlive(within: UndyingLifetime(), cacheIdentifier: cacheIdentifier)
                    .unsafely()
                    .inWindow(mockWindow)
                    .completion {
                        mockWindow.rootViewController?.presentedViewController?.dismiss(animated: false, completion: {
                            Navigate.present({ $0
                                .to(mockViewController)
                                .keepAlive(within: UndyingLifetime(), cacheIdentifier: cacheIdentifier)
                                .unsafely()
                                .inWindow(mockWindow)
                            })
                        })
                    }
                })

                it("view controller is reused", closure: {
                    expect(UndyingViewController._viewDidLoad.isInvokedOnce).toEventually(beTrue(), timeout: 3, pollInterval: 0.1)
                })
            })

            context("when presenting view controller multiple times with caching", {
                let mockWindow = MockWindow()
                let mockViewController = DyingViewController.self
                let cacheIdentifier = "dying"

                Navigate.present({ $0
                    .to(mockViewController)
                    .keepAlive(within: DyingLifetime(), cacheIdentifier: cacheIdentifier)
                    .unsafely()
                    .inWindow(mockWindow)
                    .completion {
                        mockWindow.rootViewController?.presentedViewController!.dismiss(animated: false, completion: {
                            Navigate.present({ $0
                                .to(mockViewController)
                                .keepAlive(within: DyingLifetime(), cacheIdentifier: cacheIdentifier)
                                .unsafely()
                                .inWindow(mockWindow)
                            })
                        })
                    }
                })

                it("view controller is not reused", closure: {
                    expect(DyingViewController._viewDidLoad.isInvoked(numberOfTimes: 2)).toEventually(beTrue(), timeout: 5, pollInterval: 0.1)
                })
            })
        }
    }
}
