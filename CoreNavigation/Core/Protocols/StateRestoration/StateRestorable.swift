import Foundation
import UIKit

public protocol StateRestorable{
    func withStateRestoration() -> Self
    func withStateRestoration(restorationIdentifier: String) -> Self
    func withManualStateRestoration(restorationIdentifier: String, restorationClass: UIViewControllerRestoration.Type) -> Self
}
