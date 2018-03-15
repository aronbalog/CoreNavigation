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
        Swizzler.swizzle(UIViewController.self, #selector(willMove(toParentViewController:)), #selector(coreNavigation_willMove(toParentViewController:)))
        Swizzler.swizzle(UIViewController.self, #selector(didMove(toParentViewController:)), #selector(coreNavigation_didMove(toParentViewController:)))
        Swizzler.swizzle(UIViewController.self, #selector(didReceiveMemoryWarning), #selector(coreNavigation_didReceiveMemoryWarning))
        Swizzler.swizzle(UIViewController.self, #selector(applicationFinishedRestoringState), #selector(coreNavigation_applicationFinishedRestoringState))
        
        // iOS 11
        if #available(iOS 11.0, *) {
            Swizzler.swizzle(UIViewController.self, #selector(viewLayoutMarginsDidChange), #selector(coreNavigation_viewLayoutMarginsDidChange))
            Swizzler.swizzle(UIViewController.self, #selector(viewSafeAreaInsetsDidChange), #selector(coreNavigation_viewSafeAreaInsetsDidChange))
        }
    }()
    
    @objc func coreNavigation_loadView() {
        coreNavigation_loadView()
        
        events?.loadViewBlocks.forEach({ (block) in
            block()
        })
    }
    
    @objc func coreNavigation_viewDidLoad() {
        coreNavigation_viewDidLoad()
        
        events?.viewDidLoadBlocks.forEach({ (block) in
            block()
        })
    }
    
    @objc func coreNavigation_viewWillAppear(_ animated: Bool) {
        coreNavigation_viewWillAppear(animated)
        
        events?.viewWillAppearBlocks.forEach({ (block) in
            block(animated)
        })
    }
    
    @objc func coreNavigation_viewDidAppear(_ animated: Bool) {
        coreNavigation_viewDidAppear(animated)
        
        events?.viewDidAppearBlocks.forEach({ (block) in
            block(animated)
        })
    }
    
    @objc func coreNavigation_viewWillDisappear(_ animated: Bool) {
        coreNavigation_viewWillDisappear(animated)
        
        events?.viewWillDisappearBlocks.forEach({ (block) in
            block(animated)
        })
    }
    
    @objc func coreNavigation_viewDidDisappear(_ animated: Bool) {
        coreNavigation_viewDidDisappear(animated)
        
        events?.viewDidDisappearBlocks.forEach({ (block) in
            block(animated)
        })
    }
    
    @objc func coreNavigation_viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coreNavigation_viewWillTransition(to: size, with: coordinator)
        
        events?.viewWillTransitionBlocks.forEach({ (block) in
            block(size, coordinator)
        })
    }
    
    @objc func coreNavigation_viewWillLayoutSubviews() {
        coreNavigation_viewWillLayoutSubviews()
        
        events?.viewWillLayoutSubviewsBlocks.forEach({ (block) in
            block()
        })
    }
    
    @objc func coreNavigation_viewDidLayoutSubviews() {
        coreNavigation_viewDidLayoutSubviews()
        
        events?.viewDidLayoutSubviewsBlocks.forEach({ (block) in
            block()
        })
    }
    
    @objc func coreNavigation_updateViewConstraints() {
        coreNavigation_updateViewConstraints()
        
        events?.updateViewConstraintsBlocks.forEach({ (block) in
            block()
        })
    }
    
    @objc func coreNavigation_willMove(toParentViewController: UIViewController?) {
        coreNavigation_willMove(toParentViewController: toParentViewController)
        
        events?.willMoveToBlocks.forEach({ (block) in
            block(toParentViewController)
        })
    }
    
    @objc func coreNavigation_didMove(toParentViewController: UIViewController?) {
        coreNavigation_didMove(toParentViewController: toParentViewController)
        
        events?.didMoveToBlocks.forEach({ (block) in
            block(toParentViewController)
        })
    }
    
    @objc func coreNavigation_didReceiveMemoryWarning() {
        coreNavigation_didReceiveMemoryWarning()
        
        events?.didReceiveMemoryWarningBlocks.forEach({ (block) in
            block()
        })
    }
    
    @objc func coreNavigation_applicationFinishedRestoringState() {
        coreNavigation_applicationFinishedRestoringState()
        
        events?.applicationFinishedRestoringStateBlocks.forEach({ (block) in
            block()
        })
    }
    
    @available(iOS 11.0, *)
    @objc func coreNavigation_viewLayoutMarginsDidChange() {
        coreNavigation_viewLayoutMarginsDidChange()
        events?.viewLayoutMarginsDidChangeBlocks.forEach({ (block) in
            block()
        })
    }
    
    @available(iOS 11.0, *)
    @objc func coreNavigation_viewSafeAreaInsetsDidChange() {
        coreNavigation_viewSafeAreaInsetsDidChange()
        
        events?.viewSafeAreaInsetsDidChangeBlocks.forEach({ (block) in
            block()
        })
    }
}

extension UIViewController {
    private static let association = ObjectAssociation<ViewControllerObserver>()
    
    public var events: ViewControllerObserver? {
        get { return self._events }
        set { self._events = newValue }
    }
    
    var _events: ViewControllerObserver? {
        get { return UIViewController.association[self] }
        set { UIViewController.association[self] = newValue }
    }
}
