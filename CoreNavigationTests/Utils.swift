import Foundation

import CoreNavigation

class MockApplication: UIApplicationProtocol {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    var keyWindow: UIWindow? {
        window.rootViewController = UINavigationController(rootViewController: UIViewController())
        window.makeKeyAndVisible()
        
        return window
    }
}

extension Int {
    @discardableResult mutating func invoke() -> Int {
        self += 1
        
        return self
    }
    
    var isInvokedOnce: Bool {
        return self == 1
    }
    
    func isInvoked(numberOfTimes: Int) -> Bool {
        return self == numberOfTimes
    }
}
