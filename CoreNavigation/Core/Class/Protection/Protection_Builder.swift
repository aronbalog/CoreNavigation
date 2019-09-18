extension Protection {
    class Builder: Protectable {
        let block: (Protection.Context) -> Void

        init(block: @escaping (Protection.Context) -> Void) {
            self.block = block
        }

        func protect(with context: Protection.Context) {
            block(context)
        }
    }
}
