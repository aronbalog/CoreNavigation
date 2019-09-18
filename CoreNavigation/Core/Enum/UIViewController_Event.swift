extension UIViewController {
    public enum Event<ViewControllerType: UIViewController> {
        case loadView((_ viewController: ViewControllerType) -> Void)
        case viewDidLoad((_ viewController: ViewControllerType) -> Void)
        case viewWillAppear((_ viewController: ViewControllerType, _ animated: Bool) -> Void)
        case viewDidAppear((_ viewController: ViewControllerType, _ animated: Bool) -> Void)
        case viewWillDisappear((_ viewController: ViewControllerType, _ animated: Bool) -> Void)
        case viewDidDisappear((_ viewController: ViewControllerType, _ animated: Bool) -> Void)
        case viewWillTransition((_ viewController: ViewControllerType, _ size: CGSize, _ coordinator: UIViewControllerTransitionCoordinator) -> Void)
        case viewWillLayoutSubviews((_ viewController: ViewControllerType) -> Void)
        case viewDidLayoutSubviews((_ viewController: ViewControllerType) -> Void)
        case updateViewConstraints((_ viewController: ViewControllerType) -> Void)
        case willMoveTo((_ viewController: ViewControllerType, _ parentViewController: UIViewController?) -> Void)
        case didMoveTo((_ viewController: ViewControllerType, _ parentViewController: UIViewController?) -> Void)
        case didReceiveMemoryWarning((_ viewController: ViewControllerType) -> Void)
        case applicationFinishedRestoringState((_ viewController: ViewControllerType) -> Void)

        @available(iOS 11.0, *) case viewLayoutMarginsDidChange((_ viewController: ViewControllerType) -> Void)
        @available(iOS 11.0, *) case viewSafeAreaInsetsDidChange((_ viewController: ViewControllerType) -> Void)

        public class Builder {
            let queue: DispatchQueue
            private(set) var events: [UIViewController.Event<ViewControllerType>] = []

            init(queue: DispatchQueue) {
                self.queue = queue
            }

            @discardableResult public func loadView(_ block: @escaping (ViewControllerType) -> Void) -> Self {
                queue.sync {
                    events.append(.loadView(block))
                }

                return self
            }

            @discardableResult public func viewDidLoad(_ block: @escaping (ViewControllerType) -> Void) -> Self {
                queue.sync {
                    events.append(.viewDidLoad(block))
                }

                return self
            }

            @discardableResult public func viewWillAppear(_ block: @escaping (ViewControllerType, Bool) -> Void) -> Self {
                queue.sync {
                    events.append(.viewWillAppear(block))
                }

                return self
            }

            @discardableResult public func viewDidAppear(_ block: @escaping (ViewControllerType, Bool) -> Void) -> Self {
                queue.sync {
                    events.append(.viewDidAppear(block))
                }

                return self
            }

            @discardableResult public func viewWillDisappear(_ block: @escaping (ViewControllerType, Bool) -> Void) -> Self {
                queue.sync {
                    events.append(.viewWillDisappear(block))
                }

                return self
            }

            @discardableResult public func viewDidDisappear(_ block: @escaping (ViewControllerType, Bool) -> Void) -> Self {
                queue.sync {
                    events.append(.viewDidDisappear(block))
                }

                return self
            }

            @discardableResult public func viewWillTransition(_ block: @escaping (ViewControllerType, CGSize, UIViewControllerTransitionCoordinator) -> Void) -> Self {
                queue.sync {
                    events.append(.viewWillTransition(block))
                }

                return self
            }

            @discardableResult public func viewWillLayoutSubviews(_ block: @escaping (ViewControllerType) -> Void) -> Self {
                queue.sync {
                    events.append(.viewWillLayoutSubviews(block))
                }

                return self
            }

            @discardableResult public func viewDidLayoutSubviews(_ block: @escaping (ViewControllerType) -> Void) -> Self {
                queue.sync {
                    events.append(.viewDidLayoutSubviews(block))
                }

                return self
            }

            @discardableResult public func updateViewConstraints(_ block: @escaping (ViewControllerType) -> Void) -> Self {
                queue.sync {
                    events.append(.updateViewConstraints(block))
                }

                return self
            }

            @discardableResult public func willMoveTo(_ block: @escaping (ViewControllerType, UIViewController?) -> Void) -> Self {
                queue.sync {
                    events.append(.willMoveTo(block))
                }

                return self
            }

            @discardableResult public func didMoveTo(_ block: @escaping (ViewControllerType, UIViewController?) -> Void) -> Self {
                queue.sync {
                    events.append(.didMoveTo(block))
                }

                return self
            }

            @discardableResult public func didReceiveMemoryWarning(_ block: @escaping (ViewControllerType) -> Void) -> Self {
                queue.sync {
                    events.append(.didReceiveMemoryWarning(block))
                }

                return self
            }

            @discardableResult public func applicationFinishedRestoringState(_ block: @escaping (ViewControllerType) -> Void) -> Self {
                queue.sync {
                    events.append(.applicationFinishedRestoringState(block))
                }

                return self
            }

            @available(iOS 11.0, *)
            @discardableResult public func viewLayoutMarginsDidChange(_ block: @escaping (ViewControllerType) -> Void) -> Self {
                queue.sync {
                    events.append(.viewLayoutMarginsDidChange(block))
                }

                return self
            }

            @available(iOS 11.0, *)
            @discardableResult public func viewSafeAreaInsetsDidChange(_ block: @escaping (ViewControllerType) -> Void) -> Self {
                queue.sync {
                    events.append(.viewSafeAreaInsetsDidChange(block))
                }

                return self
            }
        }

    }
}
