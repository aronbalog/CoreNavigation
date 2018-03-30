import UIKit
import Quick
import Nimble

@testable import CoreNavigation

fileprivate class MockViewController<T>: UIViewController, DataReceivingViewController {
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
                typealias Destination = MockViewController<DataType>
                
                let mockData: DataType = "data"
                let mockViewController = Destination()
                let mockWindow = MockWindow()
                
                var passedData: DataType?
                
                Navigation.push({ $0
                    .to(mockViewController)
                    .passData(mockData)
                    .on(.passData({ data in
                        passedData = data
                    }))
                    .unsafely()
                    .inWindow(mockWindow)
                })
                
                it("is pushed", closure: {
                    expect(passedData).toEventually(equal(mockData))
                    let navigationController = mockWindow.rootViewController as? UINavigationController
                    
                    expect(navigationController?.visibleViewController).toEventually(equal(mockViewController))
                })
            })
        }
    }
}
