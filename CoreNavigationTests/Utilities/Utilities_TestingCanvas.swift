import XCTest
import UIKit

struct Utilities {
    class TestingCanvas {
        private var rootWindow: UIWindow!
        private(set) var rootViewController: UIViewController
        
        init(rootViewController: UIViewController = UIViewController()) {
            self.rootViewController = rootViewController
            
            rootWindow = UIWindow(frame: UIScreen.main.bounds)
            rootWindow.isHidden = false
            rootWindow.rootViewController = rootViewController
        }
    }
}
