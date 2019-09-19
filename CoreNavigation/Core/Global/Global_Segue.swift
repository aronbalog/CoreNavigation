public func PerformSegue<FromViewControllerType: UIViewController>(_ segue: (Navigation.Segue) -> Navigation.Segue.Builder<FromViewControllerType>) -> Navigation.Operation {
    let builder = segue(Navigation.Segue(queue: queue))
    
    return Navigator(queue: queue, configuration: builder.configuration).navigate()
}

public func PerformSegue(with identifier: String) -> Navigation.Operation {
    return PerformSegue { $0
        .segue(identifier: identifier)
    }
}
