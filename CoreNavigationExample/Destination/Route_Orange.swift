import Foundation
import CoreRoute

extension Destination {
    struct Orange: Route {
        let id: String
        
        static var destination = ViewController.Orange()
        
        static var routePattern: String = "orange/<id>"
        
        var routePath: String { return "orange/\(id)" }
    }
}
