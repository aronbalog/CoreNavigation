public class ProtectionHandler {
    let onAllow: () -> Void
    let onDisallow: (Error) -> Void
    
    init(onAllow: @escaping () -> Void, onDisallow: @escaping (Error) -> Void) {
        self.onAllow = onAllow
        self.onDisallow = onDisallow
    }
    
    public func allow() {
        onAllow()
    }
    
    public func disallow(with error: Error) {
        onDisallow(error)
    }
}
