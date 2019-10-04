@discardableResult public func PerformSegue<FromViewControllerType: UIViewController>(_ segue: (Navigation.Segue<Navigation.Builder.Segue<FromViewControllerType>>) -> Navigation.Builder.Segue<FromViewControllerType>) -> Navigation.Operation {
    Navigator(queue: queue, configuration: segue(Navigation.Segue(queue: queue)).configuration).navigate()
}

@discardableResult public func PerformSegue(with identifier: String) -> Navigation.Operation {
    PerformSegue { $0
        .segue(identifier: identifier)
    }
}
