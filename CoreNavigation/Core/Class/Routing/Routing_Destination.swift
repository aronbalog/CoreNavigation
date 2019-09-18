extension Routing {
    final public class Destination: CoreNavigation.Destination, DataReceivable {
        public typealias ViewControllerType = UIViewController
        public typealias DataType = Any?

        public internal(set) var resolvedDestination: AnyDestination?

        public let route: Matchable

        init(route: Matchable) {
            self.route = route
        }

        public func didReceiveData(_ data: Any?) {
            (resolvedDestination as? AnyDataReceivable)?.didReceiveAnyData(data)
        }

        public func resolve(with resolver: Resolver<Routing.Destination>) {
            guard let match = Router.instance.match(for: route) else {
                resolver.cancel(with: Navigation.Error.routeNotFound)
                return
            }

            do {
                try match.destinationType.resolveDestination(
                    parameters: match.parameters,
                    destination: { (destination) in
                        self.resolvedDestination = destination

                        do {
                            try destination.resolveRouting(with: resolver)
                        } catch let error {
                            resolver.cancel(with: error)
                        }
                    },
                    failure: { (error) in
                        resolver.cancel(with: error)
                    }
                )
            } catch let error {
                resolver.cancel(with: error)
            }
        }
    }
}
