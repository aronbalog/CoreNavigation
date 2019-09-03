import Quick
import Nimble

import CoreNavigation

class TestPresentViewControllerCached: QuickSpec {
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
    
    let canvas = Utilities.TestingCanvas()
    private var viewController: MockViewController?
    let passingData = "mock-data"
    
    override func spec() {
        describe("When presenting") {
            context("cached UIViewController instance", {
                func present(repeatOnce: Bool) {
                    Present { $0
                        .to(MockViewController.self, from: self.canvas.rootViewController)
                        .passDataToViewController(self.passingData)
                        .cache(cacheIdentifier: "mock-identifier", { (context) in
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                                context.invalidateCache()
                            }
                        })
                        .onComplete({ (result) in
                            self.viewController = result.toViewController
                            
                            if repeatOnce {
                                Dismiss(viewController: result.toViewController, animated: false, completion: {
                                    present(repeatOnce: false)
                                })
                            }
                        })
                    }
                }
                
                present(repeatOnce: true)
                
                it("is presented", closure: {
                    expect(self.viewController?.isViewLoaded).toEventually(beTrue())
                })
                
                it("loaded once", closure: {
                    expect(MockViewController.loadCount).toEventually(equal(1))
                })
                
                it("appeared twice", closure: {
                    expect(MockViewController.appearCount).toEventually(equal(2))
                })
                
                it("view controller received data", closure: {
                    expect(self.viewController?.receivedData).toEventually(equal(self.passingData))
                })
                
                it("view controller received data twice", closure: {
                    expect(MockViewController.receivedDataCount).toEventually(equal(2))
                })
            })
        }
    }
}
