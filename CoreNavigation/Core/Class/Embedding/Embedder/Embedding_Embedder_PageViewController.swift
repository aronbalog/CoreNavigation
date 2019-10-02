extension Embedding.Embedder {
    class PageViewController: Embeddable {
        let pageViewControllerType: UIPageViewController.Type
        
        init(pageViewControllerType: UIPageViewController.Type) {
            self.pageViewControllerType = pageViewControllerType
        }
        
        func embed(with context: Embedding.Context) throws {
            DispatchQueue.main.async {
                let pageViewController = self.pageViewControllerType.init()
                
                pageViewController.setViewControllers([context.rootViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: { (_) in
                    context.complete(viewController: pageViewController)
                })
            }
        }
    }
}
