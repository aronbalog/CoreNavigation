import Foundation
import CoreRoute

public extension Route {
    public static func register(in router: Router = Navigation.router) {
        router.register(routeType: self)
    }
}
