import Foundation
#if ROUTING
import CoreRoute
#endif

extension Navigation {
    #if ROUTING
    public static let router = Router()
    #endif
}
