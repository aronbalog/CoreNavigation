extension Routing {
    final public class Destination: CoreNavigation.Destination, DataReceivable {
        public static func resolve(parameters: [String : Any]?, destination: @escaping (UIViewController) -> Void, failure: @escaping (Error?) -> Void) throws {
            fatalError()
        }
        
        public typealias ViewControllerType = UIViewController
        public typealias DataType = Any
        
        public func didReceiveData(_ data: Any) {
            
        }
        
        let route: Matchable
        
        init(route: Matchable) {
            self.route = route
        }
        
        public func resolve(with resolver: Resolver<Routing.Destination>) {
            guard let match = Router.shared.match(for: route) else {
                resolver.cancel()
                return
            }
            
            do {
                try match.destinationType.resolve(parameters: match.parameters, destination: { (viewController) in
                    resolver.complete(viewController: viewController)
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
