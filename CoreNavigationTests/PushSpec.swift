import UIKit
import Quick
import Nimble

@testable import CoreNavigation

class PushSpec: QuickSpec {
    override func spec() {
        describe("Navigation") {
            context("when pushing", {
                let viewController = UIViewController()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                    Navigation.push({ $0
                        .to(viewController)
                        .animated(true)
                        .completion {
                            print("Completed!")
                        }
                    })
                })
                
                it("is pushed", closure: {
                    let currentViewController = UIViewController.currentViewController
                    
                    expect(viewController === currentViewController).toEventually(beTrue())
                })
            })
        }
    }
}

