import UIKit
import PlaygroundSupport
import CoreNavigation

struct Object {
    let id: String
}

func fetchObject(id: String, completion: @escaping (Object) -> Void, failure: @escaping (Error) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        let object = Object(id: id)
        completion(object)
    }
}

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
}

class OtherViewController: UIViewController, DataReceivable {
    typealias DataType = Object

    let label = UILabel()
    var data: Object!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        view.addSubview(label)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        label.text = "Object id: \(data.id)"
        label.sizeToFit()
        label.center = view.center
    }

    func didReceiveData(_ data: Object) {
        self.data = data
    }
}

struct MyDestination: Destination {
    typealias ViewControllerType = MyViewController
}

struct OtherDestination: Destination, Routable {
    typealias ViewControllerType = OtherViewController
    static var patterns: [String] = [
        "https://appdomain.com/other/:id(.*)"
    ]

    static func resolve(context: Context<OtherDestination>) {
        guard let id = context.parameters?["id"] as? String else {
            context.cancel()
            return
        }

        fetchObject(id: id, completion: { (object) in
            context.complete(data: object)
        }) { (error) in
            context.cancel(error: error)
        }
    }
}

OtherDestination.register()

let rootViewController = try! MyDestination().viewController()

PlaygroundPage.current.liveView = UINavigationController(rootViewController: rootViewController)

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    Navigate.push { $0
        .to("https://appdomain.com/other/corenavigation")
    }
}
