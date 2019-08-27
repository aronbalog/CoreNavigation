class BuilderProtection: Protectable {
    let block: (ProtectionHandler) -> Void
    
    init(block: @escaping (ProtectionHandler) -> Void) {
        self.block = block
    }
    
    func protect(handler: ProtectionHandler) {
        block(handler)
    }
}
