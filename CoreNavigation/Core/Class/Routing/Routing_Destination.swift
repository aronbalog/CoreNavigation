extension Routing {
    final public class Destination: CoreNavigation.Destination {
        public typealias ViewControllerType = UIViewController
        
        let route: Matchable
        
        init(route: Matchable) {
            self.route = route
        }
        
        public func resolve(with resolver: Resolver<Routing.Destination>) {
            if let match = Router.shared.match(for: route) {
                match.destinationType.resolve(parameters: match.parameters, destination: { (viewController) in
                    resolver.complete(viewController: viewController)
                }) { (error) in
                    if let error = error {
                        resolver.cancel(with: error)
                    }
                    resolver.cancel()
                }
            }
        }
    }
}
