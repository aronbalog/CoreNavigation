import Foundation

public protocol TransitioningAware: class {
    var animated: Bool { get set }
    var completionBlocks: [() -> Void] { get set }
}
