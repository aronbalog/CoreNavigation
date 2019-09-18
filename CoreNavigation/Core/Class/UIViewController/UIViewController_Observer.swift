extension UIViewController {
    class Observer {
        var loadViewBlocks: [(UIViewController) -> Void] = []
        var viewDidLoadBlocks: [(UIViewController) -> Void] = []
        var viewWillAppearBlocks: [(UIViewController, Bool) -> Void] = []
        var viewDidAppearBlocks: [(UIViewController, Bool) -> Void] = []
        var viewWillDisappearBlocks: [(UIViewController, Bool) -> Void] = []
        var viewDidDisappearBlocks: [(UIViewController, Bool) -> Void] = []
        var viewWillTransitionBlocks: [(UIViewController, CGSize, UIViewControllerTransitionCoordinator) -> Void] = []
        var viewWillLayoutSubviewsBlocks: [(UIViewController) -> Void] = []
        var viewDidLayoutSubviewsBlocks: [(UIViewController) -> Void] = []
        var viewLayoutMarginsDidChangeBlocks: [(UIViewController) -> Void] = []
        var viewSafeAreaInsetsDidChangeBlocks: [(UIViewController) -> Void] = []
        var updateViewConstraintsBlocks: [(UIViewController) -> Void] = []
        var willMoveToBlocks: [(UIViewController, UIViewController?) -> Void] = []
        var didMoveToBlocks: [(UIViewController, UIViewController?) -> Void] = []
        var didReceiveMemoryWarningBlocks: [(UIViewController) -> Void] = []
        var applicationFinishedRestoringStateBlocks: [(UIViewController) -> Void] = []

        func onLoadView(_ loadView: @escaping (UIViewController) -> Void) {
            loadViewBlocks.append(loadView)
        }

        func onViewDidLoad(_ viewDidLoad: @escaping (UIViewController) -> Void) {
            viewDidLoadBlocks.append(viewDidLoad)
        }

        func onViewWillAppear(_ viewWillAppear: @escaping (UIViewController, Bool) -> Void) {
            viewWillAppearBlocks.append(viewWillAppear)
        }

        func onViewDidAppear(_ viewDidAppear: @escaping (UIViewController, Bool) -> Void) {
            viewDidAppearBlocks.append(viewDidAppear)
        }

        func onViewWillDisappear(_ viewWillDisappear: @escaping (UIViewController, Bool) -> Void) {
            viewWillDisappearBlocks.append(viewWillDisappear)
        }

        func onViewDidDisappear(_ viewDidDisappear: @escaping (UIViewController, Bool) -> Void) {
            viewDidDisappearBlocks.append(viewDidDisappear)
        }

        func onViewWillTransition(_ viewWillTransition: @escaping (UIViewController, CGSize, UIViewControllerTransitionCoordinator) -> Void) {
            viewWillTransitionBlocks.append(viewWillTransition)
        }

        func onViewWillLayoutSubviews(_ viewWillLayoutSubviews: @escaping (UIViewController) -> Void) {
            viewWillLayoutSubviewsBlocks.append(viewWillLayoutSubviews)
        }

        func onViewDidLayoutSubviews(_ viewDidLayoutSubviews: @escaping (UIViewController) -> Void) {
            viewDidLayoutSubviewsBlocks.append(viewDidLayoutSubviews)
        }

        func onViewLayoutMarginsDidChange(_ viewLayoutMarginsDidChange: @escaping (UIViewController) -> Void) {
            viewLayoutMarginsDidChangeBlocks.append(viewLayoutMarginsDidChange)
        }

        func onViewSafeAreaInsetsDidChange(_ viewSafeAreaInsetsDidChange: @escaping (UIViewController) -> Void) {
            viewSafeAreaInsetsDidChangeBlocks.append(viewSafeAreaInsetsDidChange)
        }

        func onUpdateViewConstraints(_ updateViewConstraints: @escaping (UIViewController) -> Void) {
            updateViewConstraintsBlocks.append(updateViewConstraints)
        }

        func onWillMoveTo(_ willMoveTo: @escaping (UIViewController, UIViewController?) -> Void) {
            willMoveToBlocks.append(willMoveTo)
        }

        func onDidMoveTo(_ didMoveTo: @escaping (UIViewController, UIViewController?) -> Void) {
            didMoveToBlocks.append(didMoveTo)
        }

        func onDidReceiveMemoryWarning(_ didReceiveMemoryWarning: @escaping (UIViewController) -> Void) {
            didReceiveMemoryWarningBlocks.append(didReceiveMemoryWarning)
        }

        func onApplicationFinishedRestoringState(_ applicationFinishedRestoringState: @escaping (UIViewController) -> Void) {
            applicationFinishedRestoringStateBlocks.append(applicationFinishedRestoringState)
        }
    }

}
