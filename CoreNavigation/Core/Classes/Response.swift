import UIKit

public class Response<FromViewController: UIViewController, ToViewController: UIViewController, EmbeddingViewController: UIViewController> {
    
    private var _toViewController: ToViewController?

    internal(set) public weak var fromViewController: FromViewController?
    internal(set) public weak var toViewController: ToViewController?
    internal(set) public weak var embeddingViewController: EmbeddingViewController?
    internal(set) public var parameters: [String: Any]?

    init(fromViewController: FromViewController?, toViewController: ToViewController?, embeddingViewController: EmbeddingViewController?, releaseDestination: Bool = true) {
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        self.embeddingViewController = embeddingViewController
        
        if !releaseDestination {
            self._toViewController = toViewController
        }
    }
}
