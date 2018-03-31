import Foundation

enum StateRestorationOption {
    case ignore
    case automatically
    case automaticallyWithIdentifier(restorationIdentifier: String)
    case manually(restorationIdentifier: String, restorationClass: UIViewControllerRestoration.Type?)
}
