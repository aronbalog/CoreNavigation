import Foundation

/// All destinations inherits from `AnyDestination` protocol. Use `Destination` protocol instead.
public protocol AnyDestination {
    /// Resolves destination.
    ///
    /// - Parameters:
    ///   - parameters: Parameters extracted from route's uri.
    ///   - destination: Call this block when resolved and pass viewController and optional data.
    ///   - failure: Call this block and pass optional error to cancel routing.
    static func resolve(parameters: [String: Any]?, destination: @escaping (UIViewController, Any?) -> Void, failure: @escaping (Error?) -> Void)
}

// MARK: - Default implementation of AnyDestination
extension AnyDestination where Self: Destination {
    /// Resolves destination.
    ///
    /// - Parameters:
    ///   - parameters: Parameters extracted from route's uri.
    ///   - destination: Call this block when resolved and pass viewController and optional data.
    ///   - failure: Call this block and pass optional error to cancel routing.
    public static func resolve(parameters: [String: Any]?, destination: @escaping (UIViewController, Any?) -> Void, failure: @escaping (Error?) -> Void) {
        let context = Context<Self>(parameters: parameters)
        
        context.destinationBlocks.append(destination)
        context.cancelBlocks.append(failure)
        
        resolve(context: context)
    }
}
