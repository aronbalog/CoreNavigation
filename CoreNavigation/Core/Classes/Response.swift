import UIKit

public class Response<FromViewController: UIViewController, ToViewController: UIViewController, EmbeddingViewController: UIViewController> {
    
    public weak var fromViewController: FromViewController?
    public weak var toViewController: ToViewController?
    public weak var embeddingViewController: EmbeddingViewController?
    
    init(fromViewController: FromViewController?, toViewController: ToViewController?, embeddingViewController: EmbeddingViewController?) {
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        self.embeddingViewController = embeddingViewController
    }
}
