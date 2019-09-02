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
            guard let match = Router.instance.match(for: route) else {
                resolver.cancel()
                return
            }
            
            do {
                try match.destinationType.resolveDestination(parameters: match.parameters, destination: { (destination) in
                    self.potentialDataReceivable = destination as? AnyDataReceivable
                    
                    do {
                        try destination.resolveRouting(with: resolver)
                    } catch let error {
                        resolver.cancel(with: error)
                    }
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
    }
}
