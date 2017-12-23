import UIKit

public protocol ResponseAware {
    func didReceiveResponse(_ response: Response<UIViewController, UIViewController, UIViewController>)
}
