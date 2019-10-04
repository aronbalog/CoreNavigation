extension Navigation.Builder.To {
    @discardableResult public func protect(with protections: Protectable...) -> Self {
        queue.sync { configuration.protections.append(contentsOf: protections) }

        return self
    }

    @discardableResult public func protect(_ block: @escaping (Protection.Context) -> Void) -> Self {
        queue.sync { configuration.protections.append(Protection.Builder(block: block)) }

        return self
    }
}
