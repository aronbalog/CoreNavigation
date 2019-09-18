extension Destination {
    public func navigate<FromType: UIViewController>(_ navigationType: Navigation.Direction.Forward, _ to: (Navigation.To.Builder<Self, FromType>) -> Navigation.To.Builder<Self, FromType>) {
        Navigate(navigationType, { to($0.to(self)) })
    }

    public func present<FromType: UIViewController>(_ to: (Navigation.To.Builder<Self, FromType>) -> Navigation.To.Builder<Self, FromType>) {
        navigate(.present, to)
    }

    public func push<FromType: UIViewController>(_ to: (Navigation.To.Builder<Self, FromType>) -> Navigation.To.Builder<Self, FromType>) {
        navigate(.push, to)
    }

    public func viewController(_ block: @escaping (Self.ViewControllerType) -> Void, _ failure: ((Error) -> Void)? = nil) {
        let builder = Navigation.ViewController.Builder(configuration: Navigation.ViewController(queue: queue).viewController(for: self).configuration, queue: queue)

        Navigator(queue: queue).resolve(
            with: builder.configuration,
            onComplete: { (_, viewController, _) in
                block(viewController)
            },
            onCancel: { failure?($0) })
    }

    public func viewController() throws -> Self.ViewControllerType {
        var resolvedViewController: Self.ViewControllerType?
        var resolvedError: Error?

        viewController({ (viewController) in
                resolvedViewController = viewController
            }, { (error) in
                resolvedError = error
            })

        if let error = resolvedError {
            throw error
        }

        guard let viewController = resolvedViewController else {
            throw Navigation.Error.unknown
        }

        return viewController
    }

    func resolvedDestination(_ block: @escaping (Self) -> Void, _ failure: ((Error) -> Void)? = nil) {
        let builder = Navigation.ViewController.Builder(configuration: Navigation.ViewController(queue: queue).viewController(for: self).configuration, queue: queue)

        Navigator(queue: queue).resolve(
            with: builder.configuration,
            onComplete: { (destination, _, _) in
                block(destination)
            },
            onCancel: { failure?($0) }
        )
    }

    func resolvedDestination() throws -> Self {
        var resolvedDestination: Self!
        var resolvedError: Error?

        self.resolvedDestination({ (destination) in
            resolvedDestination = destination
        }, { (error) in
            resolvedError = error
        })

        if let error = resolvedError {
            throw error
        }

        return resolvedDestination
    }
}
