import Foundation
import UIKit

public func present(_ configuration: @escaping (Configuration.Present) -> Void) {
    Navigation.present(configuration)
}

public func push(_ configuration: @escaping (Configuration.Push) -> Void) {
    Navigation.push(configuration)
}

public func response(_ configuration: (Configuration.Response) -> Void)  -> Response<UIViewController, UIViewController, UIViewController>? {
    return Navigation.response(configuration)
}
