import UIKit

public protocol ViewControllerEmbedding {
    init(with response: Response<UIViewController, UIViewController, UIViewController>)
}
