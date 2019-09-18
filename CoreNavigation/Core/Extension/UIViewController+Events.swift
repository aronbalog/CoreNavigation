import UIKit

extension UIViewController {
    static let swizzleMethods: Void = {
        Swizzler.swizzle(UIViewController.self, #selector(loadView), #selector(coreNavigation_loadView))
        Swizzler.swizzle(UIViewController.self, #selector(viewDidLoad), #selector(coreNavigation_viewDidLoad))
        Swizzler.swizzle(UIViewController.self, #selector(viewWillAppear(_:)), #selector(coreNavigation_viewWillAppear(_:)))
        Swizzler.swizzle(UIViewController.self, #selector(viewDidAppear(_:)), #selector(coreNavigation_viewDidAppear(_:)))
        Swizzler.swizzle(UIViewController.self, #selector(viewWillDisappear(_:)), #selector(coreNavigation_viewWillDisappear(_:)))
        Swizzler.swizzle(UIViewController.self, #selector(viewDidDisappear(_:)), #selector(coreNavigation_viewDidDisappear(_:)))
        Swizzler.swizzle(UIViewController.self, #selector(viewWillTransition(to:with:)), #selector(coreNavigation_viewWillTransition(to:with:)))
        Swizzler.swizzle(UIViewController.self, #selector(viewWillLayoutSubviews), #selector(coreNavigation_viewWillLayoutSubviews))
        Swizzler.swizzle(UIViewController.self, #selector(viewDidLayoutSubviews), #selector(coreNavigation_viewDidLayoutSubviews))
        Swizzler.swizzle(UIViewController.self, #selector(updateViewConstraints), #selector(coreNavigation_updateViewConstraints))
        Swizzler.swizzle(UIViewController.self, #selector(willMove), #selector(coreNavigation_willMove(toParentViewController:)))
        Swizzler.swizzle(UIViewController.self, #selector(didMove), #selector(coreNavigation_didMove(toParentViewController:)))
        Swizzler.swizzle(UIViewController.self, #selector(didReceiveMemoryWarning), #selector(coreNavigation_didReceiveMemoryWarning))
        Swizzler.swizzle(UIViewController.self, #selector(applicationFinishedRestoringState), #selector(coreNavigation_applicationFinishedRestoringState))
        Swizzler.swizzle(UIViewController.self, #selector(prepare(for:sender:)), #selector(coreNavigation_prepareForSegue))

        // iOS 11
        if #available(iOS 11.0, *) {
            Swizzler.swizzle(UIViewController.self, #selector(viewLayoutMarginsDidChange), #selector(coreNavigation_viewLayoutMarginsDidChange))
            Swizzler.swizzle(UIViewController.self, #selector(viewSafeAreaInsetsDidChange), #selector(coreNavigation_viewSafeAreaInsetsDidChange))
        }
    }()

    @objc func coreNavigation_loadView() {
        coreNavigation_loadView()

        coreNavigationEvents?.loadViewBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self)
        })
    }

    @objc func coreNavigation_viewDidLoad() {
        coreNavigation_viewDidLoad()

        coreNavigationEvents?.viewDidLoadBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self)
        })
    }

    @objc func coreNavigation_viewWillAppear(_ animated: Bool) {
        coreNavigation_viewWillAppear(animated)

        coreNavigationEvents?.viewWillAppearBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self, animated)
        })
    }

    @objc func coreNavigation_viewDidAppear(_ animated: Bool) {
        coreNavigation_viewDidAppear(animated)

        coreNavigationEvents?.viewDidAppearBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self, animated)
        })
    }

    @objc func coreNavigation_viewWillDisappear(_ animated: Bool) {
        coreNavigation_viewWillDisappear(animated)

        coreNavigationEvents?.viewWillDisappearBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self, animated)
        })
    }

    @objc func coreNavigation_viewDidDisappear(_ animated: Bool) {
        coreNavigation_viewDidDisappear(animated)

        coreNavigationEvents?.viewDidDisappearBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self, animated)
        })
    }

    @objc func coreNavigation_viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coreNavigation_viewWillTransition(to: size, with: coordinator)

        coreNavigationEvents?.viewWillTransitionBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self, size, coordinator)
        })
    }

    @objc func coreNavigation_viewWillLayoutSubviews() {
        coreNavigation_viewWillLayoutSubviews()

        coreNavigationEvents?.viewWillLayoutSubviewsBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self)
        })
    }

    @objc func coreNavigation_viewDidLayoutSubviews() {
        coreNavigation_viewDidLayoutSubviews()

        coreNavigationEvents?.viewDidLayoutSubviewsBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self)
        })
    }

    @objc func coreNavigation_updateViewConstraints() {
        coreNavigation_updateViewConstraints()

        coreNavigationEvents?.updateViewConstraintsBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self)
        })
    }

    @objc func coreNavigation_willMove(toParentViewController: UIViewController?) {
        coreNavigation_willMove(toParentViewController: toParentViewController)

        coreNavigationEvents?.willMoveToBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self, toParentViewController)
        })
    }

    @objc func coreNavigation_didMove(toParentViewController: UIViewController?) {
        coreNavigation_didMove(toParentViewController: toParentViewController)

        coreNavigationEvents?.didMoveToBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self, toParentViewController)
        })
    }

    @objc func coreNavigation_didReceiveMemoryWarning() {
        coreNavigation_didReceiveMemoryWarning()

        coreNavigationEvents?.didReceiveMemoryWarningBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self)
        })
    }

    @objc func coreNavigation_applicationFinishedRestoringState() {
        coreNavigation_applicationFinishedRestoringState()

        coreNavigationEvents?.applicationFinishedRestoringStateBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self)
        })
    }
    
    @objc func coreNavigation_prepareForSegue(for segue: UIStoryboardSegue, sender: Any?) {
        coreNavigation_prepareForSegue(for: segue, sender: sender)
        
        coreNavigationEvents?.prepareForSegueBlocks.forEach({
            $0(segue, sender)
        })
    }

    @available(iOS 11.0, *)
    @objc func coreNavigation_viewLayoutMarginsDidChange() {
        coreNavigation_viewLayoutMarginsDidChange()

        coreNavigationEvents?.viewLayoutMarginsDidChangeBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self)
        })
    }

    @available(iOS 11.0, *)
    @objc func coreNavigation_viewSafeAreaInsetsDidChange() {
        coreNavigation_viewSafeAreaInsetsDidChange()

        coreNavigationEvents?.viewSafeAreaInsetsDidChangeBlocks.forEach({ [weak self] in
            guard let `self` = self else { return }

            $0(self)
        })
    }
}

extension UIViewController {
    private static let association = ObjectAssociation<UIViewController.Observer>()

    var coreNavigationEvents: UIViewController.Observer? {
        get { return UIViewController.association[self] }
        set { UIViewController.association[self] = newValue }
    }
}
