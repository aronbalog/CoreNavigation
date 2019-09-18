extension Protection {
    class Chain: Protectable {
        var protectables: [Protectable]

        init(protectables: [Protectable]) {
            self.protectables = protectables
        }

        func protect(with context: Protection.Context) throws {
            let newContext = Protection.Context(onAllow: {
                self.protectables.removeFirst()

                if self.protectables.isEmpty {
                    context.allow()
                } else {
                    do {
                        try self.protect(with: context)
                    } catch let error {
                        context.disallow(with: error)
                    }
                }
            }, onDisallow: context.disallow)

            if let firstProtectable = protectables.first {
                try firstProtectable.protect(with: newContext)
            } else {
                context.allow()
            }
        }

    }
}
