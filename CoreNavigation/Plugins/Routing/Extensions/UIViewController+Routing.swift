#if ROUTING
import UIKit
import CoreRoute

public extension UIViewController {
    static func from<R: Route>(route: R) -> UIViewController? {
        var response: Response<UIViewController, UIViewController, UIViewController>?
        
        response = Navigation.response({ $0
            .to(route)
            .withStateRestoration()
        })
        
        return response?.toViewController
    }
}

#endif

