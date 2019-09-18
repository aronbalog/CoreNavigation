let queue = DispatchQueue(label: "corenavigation.queue", attributes: .concurrent)

let initFramework: Void = {
    UIViewController.swizzleMethods
}()
