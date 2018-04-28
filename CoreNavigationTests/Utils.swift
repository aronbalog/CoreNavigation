import Foundation

import CoreNavigation

class MockWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)

        rootViewController = UINavigationController(rootViewController: UIViewController())
        makeKeyAndVisible()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
