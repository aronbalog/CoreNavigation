public func PerformSegue<FromViewControllerType: UIViewController>(_ segue: (Navigation.Segue) -> Navigation.Segue.Builder<FromViewControllerType>) {
    Navigator(queue: queue).navigate(with: segue(Navigation.Segue(queue: queue)).configuration)
}

public func PerformSegue(with identifier: String) {
    PerformSegue { $0
        .segue(identifier: identifier)
    }
}
