import UIKit

public class Response<FromViewController: UIViewController, ToViewController: UIViewController, EmbeddingViewController: UIViewController> {
    
    internal(set) public weak var fromViewController: FromViewController?
    internal(set) public weak var toViewController: ToViewController?
    internal(set) public weak var embeddingViewController: EmbeddingViewController?
    
    init(fromViewController: FromViewController?, toViewController: ToViewController?, embeddingViewController: EmbeddingViewController?) {
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        self.embeddingViewController = embeddingViewController
    }
}
