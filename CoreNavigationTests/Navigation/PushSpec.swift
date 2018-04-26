import UIKit
import Quick
import Nimble

@testable import CoreNavigation

fileprivate class MockViewController<T>: UIViewController, DataReceivable {
    var receivedData: T?
    
    func didReceiveData(_ data: T) {
        receivedData = data
    }
    
    typealias DataType = T
}

class PushSpec: QuickSpec {
    override func spec() {
        describe("Navigation") {
            context("when pushing", {
                typealias DataType = String
                typealias ViewController = MockViewController<DataType>
                
                let mockData: DataType = "data"
                let mockViewController = ViewController()
                let mockWindow = MockWindow()
                                
                Navigate.push({ $0
                    .to(mockViewController)
                    .passData(mockData)
                    .unsafely()
                    .inWindow(mockWindow)
                })
                
                it("is pushed", closure: {
                    expect(mockViewController.receivedData).toEventually(equal(mockData))
                    let navigationController = mockWindow.rootViewController as? UINavigationController
                    
                    expect(navigationController?.visibleViewController).toEventually(equal(mockViewController))
                })
            })
        }
    }
}
