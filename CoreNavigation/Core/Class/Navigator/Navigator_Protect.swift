extension Navigator {
    func protectNavigation<DestinationType: Destination, FromType: UIViewController>(
        configuration: Configuration<DestinationType, FromType>,
        onAllow: @escaping () -> Void,
        onDisallow: @escaping (Error) -> Void) {
        if !configuration.protections.isEmpty {
            handleProtection(with: Protection.Chain(protectables: configuration.protections), onAllow: onAllow, onDisallow: onDisallow)
        } else if let protectable = configuration.destination as? Protectable {
            handleProtection(with: protectable, onAllow: onAllow, onDisallow: onDisallow)
        } else if let protectable = configuration.embeddable as? Protectable {
            handleProtection(with: protectable, onAllow: onAllow, onDisallow: onDisallow)
        } else {
            onAllow()
        }
    }
    private func handleProtection(with protectable: Protectable, onAllow: @escaping () -> Void, onDisallow: @escaping (Error) -> Void) {
        do {
            try protectable.protect(with: Protection.Context(onAllow: onAllow, onDisallow: onDisallow))
        } catch let error {
            onDisallow(error)
        }
    }
}
