import Quick
import Nimble

import CoreNavigation

class TestPresentViewControllerProtected: QuickSpec {
    private class MockViewController: UIViewController, DataReceivable {
        typealias DataType = String
        
        var receivedData: String?
        static var loadCount: Int = 0
        static var appearCount: Int = 0
        static var receivedDataCount: Int = 0
        
        func didReceiveData(_ data: String) {
            receivedData = data
            
            MockViewController.receivedDataCount += 1
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            MockViewController.loadCount += 1
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            MockViewController.appearCount += 1
        }
    }
    
    private class MockProtectable: Protectable {
        let secondsToWait: TimeInterval
        var isAllowed: Bool = false
        
        init(secondsToWait: TimeInterval) {
            self.secondsToWait = secondsToWait
        }
        
        func protect(with context: Protection.Context) throws {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + secondsToWait) {
                self.isAllowed = true
                context.allow()
            }
        }
    }
    
    let canvas = Utilities.TestingCanvas()
    private var viewController: MockViewController?
    let passingData = "mock-data"
    
    override func spec() {
        describe("When presenting") {
            context("protected UIViewController instance", {
                let protectable = MockProtectable(secondsToWait: 1)
                Present { $0
                    .to(MockViewController.self, from: self.canvas.rootViewController)
                    .passDataToViewController(self.passingData)
                    .protect(with: protectable)
                    .onComplete({ (result) in
                        self.viewController = result.toViewController
                    })
                }
                
                it("is presented", closure: {
                    expect(self.viewController?.isViewLoaded).toEventually(beTrue())
                })
                
                it("view controller received data", closure: {
                    expect(self.viewController?.receivedData).toEventually(equal(self.passingData))
                })
                
                it("protectable allowed protection", closure: {
                    expect(protectable.isAllowed).toEventually(beTrue())
                })
            })
        }
    }
}
