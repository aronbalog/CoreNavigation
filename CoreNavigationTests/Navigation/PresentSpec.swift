import UIKit
import Quick
import Nimble

import CoreNavigation

fileprivate class MockViewController<T>: UIViewController, DataReceivable {
    var receivedData: T?
    
    func didReceiveData(_ data: T) {
        receivedData = data
    }
    
    typealias DataType = T
}

fileprivate class MockTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
}

class PresentSpec: QuickSpec {
    override func spec() {
        describe("Navigation") {
            context("when presenting", {
                typealias DataType = String
                typealias ViewController = MockViewController<DataType>
                
                let mockData: DataType = "data"
                let mockViewController = ViewController()
                let mockTransitioningDelegate = MockTransitioningDelegate()
                
                var completionInvokes = 0
                var passedViewController: Destination?

                Navigation.present({ $0
                    .to(mockViewController)
                    .animated(true)
                    .transitioningDelegate(mockTransitioningDelegate)
                    .passData(mockData)
                    .embeddedInNavigationController()
                    .on(.completion({
                        completionInvokes.invoke()
                    }))
                    .on(.viewController(.viewDidLoad {
                        print($0.view)
                    }))
                    .on(.viewController(.viewDidLoad { viewController in
                        passedViewController = viewController
                    }))
                    .completion {
                        completionInvokes.invoke()
                    }
                    .unsafely()
                    .inWindow(MockWindow())
                })
                
                it("is presented", closure: {
                    expect(completionInvokes).toEventually(be(2))
                    expect(mockViewController.receivedData).toEventually(equal(mockData))
                    expect(mockViewController).toEventually(equal(passedViewController))
                })
            })
            
            context("when presenting", {
                typealias DataType = String
                typealias ViewController = MockViewController<DataType>
                
                let mockViewController = ViewController()
                
                MockWindow().rootViewController?.present({ $0
                    .to(mockViewController)
                })
                
                it("is presented", closure: {
                    expect(mockViewController.isViewLoaded).toEventually(beTrue())
                })
            })
        }
    }
}
