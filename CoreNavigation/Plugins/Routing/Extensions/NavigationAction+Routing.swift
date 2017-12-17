import Foundation
#if ROUTING
import CoreRoute
#endif

extension NavigationAction {
    #if ROUTING
    @discardableResult public func to<RouteType: AbstractRoute>(_ route: RouteType, in router: Router = Navigation.router) -> Self {
        configuration.destination.target = (route, router)
        
        return self
    }
    #endif
}
