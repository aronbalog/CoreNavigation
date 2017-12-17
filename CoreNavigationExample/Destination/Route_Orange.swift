import Foundation
import CoreRoute

extension Destination {
    class Orange: Route {
        lazy var destination = ViewController.Orange.self
        
        var routePath: String = "orange"
    }
}
