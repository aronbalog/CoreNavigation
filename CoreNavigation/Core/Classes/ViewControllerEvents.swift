import Foundation

public class ViewControllerEvents {
    var loadViewBlocks: [() -> Void] = []
    var viewDidLoadBlocks: [() -> Void] = []
    var viewWillAppearBlocks: [(Bool) -> Void] = []
    var viewDidAppearBlocks: [(Bool) -> Void] = []
    var viewWillDisappearBlocks: [(Bool) -> Void] = []
    var viewDidDisappearBlocks: [(Bool) -> Void] = []
    var viewWillTransitionBlocks: [((CGSize, UIViewControllerTransitionCoordinator) -> Void)] = []
    var viewWillLayoutSubviewsBlocks: [(() -> Void)] = []
    var viewDidLayoutSubviewsBlocks: [(() -> Void)] = []
    var viewLayoutMarginsDidChangeBlocks: [(() -> Void)] = []
    var viewSafeAreaInsetsDidChangeBlocks: [(() -> Void)] = []
    var updateViewConstraintsBlocks: [(() -> Void)] = []
    var willMoveToBlocks: [((UIViewController?) -> Void)] = []
    var didMoveToBlocks: [((UIViewController?) -> Void)] = []
    var didReceiveMemoryWarningBlocks: [(() -> Void)] = []
    var applicationFinishedRestoringStateBlocks: [(() -> Void)] = []

    func onLoadView(_ loadView: @escaping () -> Void) {
        loadViewBlocks.append(loadView)
    }
    
    func onViewDidLoad(_ viewDidLoad: @escaping () -> Void) {
        viewDidLoadBlocks.append(viewDidLoad)
    }
    
    func onViewWillAppear(_ viewWillAppear: @escaping (Bool) -> Void) {
        viewWillAppearBlocks.append(viewWillAppear)
    }
    
    func onViewDidAppear(_ viewDidAppear: @escaping (Bool) -> Void) {
        viewDidAppearBlocks.append(viewDidAppear)
    }
    
    func onViewWillDisappear(_ viewWillDisappear: @escaping (Bool) -> Void) {
        viewWillDisappearBlocks.append(viewWillDisappear)
    }
    
    func onViewDidDisappear(_ viewDidDisappear: @escaping (Bool) -> Void) {
        viewDidDisappearBlocks.append(viewDidDisappear)
    }
    
    func onViewWillTransition(_ viewWillTransition: @escaping (CGSize, UIViewControllerTransitionCoordinator) -> Void) {
        viewWillTransitionBlocks.append(viewWillTransition)
    }
    
    func onViewWillLayoutSubviews(_ viewWillLayoutSubviews: @escaping () -> Void) {
        viewWillLayoutSubviewsBlocks.append(viewWillLayoutSubviews)
    }
    
    func onViewDidLayoutSubviews(_ viewDidLayoutSubviews: @escaping () -> Void) {
        viewDidLayoutSubviewsBlocks.append(viewDidLayoutSubviews)
    }
    
    func onViewLayoutMarginsDidChange(_ viewLayoutMarginsDidChange: @escaping () -> Void) {
        viewLayoutMarginsDidChangeBlocks.append(viewLayoutMarginsDidChange)
    }
    
    func onViewSafeAreaInsetsDidChange(_ viewSafeAreaInsetsDidChange: @escaping () -> Void) {
        viewSafeAreaInsetsDidChangeBlocks.append(viewSafeAreaInsetsDidChange)
    }
    
    func onUpdateViewConstraints(_ updateViewConstraints: @escaping () -> Void) {
        updateViewConstraintsBlocks.append(updateViewConstraints)
    }
    
    func onWillMoveTo(_ willMoveTo: @escaping (UIViewController?) -> Void) {
        willMoveToBlocks.append(willMoveTo)
    }
    
    func onDidMoveTo(_ didMoveTo: @escaping (UIViewController?) -> Void) {
        didMoveToBlocks.append(didMoveTo)
    }
    
    func onDidReceiveMemoryWarning(_ didReceiveMemoryWarning: @escaping () -> Void) {
        didReceiveMemoryWarningBlocks.append(didReceiveMemoryWarning)
    }
    
    func onApplicationFinishedRestoringState(_ applicationFinishedRestoringState: @escaping () -> Void) {
        applicationFinishedRestoringStateBlocks.append(applicationFinishedRestoringState)
    }
}

