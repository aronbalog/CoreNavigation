extension Routing {
    final public class Destination: CoreNavigation.Destination, DataReceivable {
        public typealias ViewControllerType = UIViewController
        public typealias DataType = Any?
        
        var potentialDataReceivable: AnyDataReceivable?
        
        public let route: Matchable
        
        init(route: Matchable) {
            self.route = route
        }
        
        public func didReceiveData(_ data: Any?) {
            potentialDataReceivable?.didReceiveAnyData(data)
        }
        
        public func resolve(with resolver: Resolver<Routing.Destination>) {
            guard let match = Router.shared.match(for: route) else {
                resolver.cancel()
                return
            }
            
            do {
                try match.destinationType.resolveDestination(parameters: match.parameters, destination: { (destination) in
                    self.potentialDataReceivable = destination as? AnyDataReceivable
                    
                    destination.resolveRouting(with: resolver)
                }) { (error) in
                    if let error = error {
                        resolver.cancel(with: error)
                    }
                    resolver.cancel()
                }
            } catch let error {
                resolver.cancel(with: error)
            }
        }
        
        public func resolveRouting(with resolver: Resolver<Routing.Destination>) {
            // never gonna happen
        }
        
        public static func resolveDestination(parameters: [String : Any]?, destination: @escaping (Routing.Destination) -> Void, failure: @escaping (Error?) -> Void) throws {
            // never gonna happen
        }
        
    }
}
