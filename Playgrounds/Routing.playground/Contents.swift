import UIKit
import PlaygroundSupport
import CoreNavigation

// Helper

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

// View controllers

class ColorViewController: UIViewController, DataReceivable {
    typealias DataType = UIColor
    
    func didReceiveData(_ data: UIColor) {
        view.backgroundColor = data
    }
}

class OtherViewController: UIViewController, Routable, DataReceivable {
    typealias DataType = [String: Any]

    static var patterns: [String] = [
        "https://appdomain.com/other/:id/:firstName/:lastName"
    ]
    
    let label = UILabel()
    var data: DataType?

    func didReceiveData(_ data: [String: Any]) {
        self.data = data
        
        let _data = try! JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
        let string = String(data: _data, encoding: .utf8)
        
        label.text = string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        label.numberOfLines = 0
//        label.textAlignment = .center
        view.addSubview(label)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.frame = view.bounds
    }
}

/* ------------------------------------- */

// Destination

struct ColorDestination: Destination, Routable {
    typealias ViewControllerType = ColorViewController
    
    static var patterns: [String] = [
        "https://appdomain.com/color"
    ]
    
    static func resolve(context: Context<ColorViewController>) {
        guard
            let rgb = context.parameters?["rgb"] as? String
        else {
            context.cancel()
            return
        }
        
        let color = UIColor.init(hexString: rgb)
        
        context.complete(data: color)
    }
}

/* ------------------------------------- */

// Register routable types
OtherViewController.register()
ColorDestination.register()

// Get root view controller
let rootViewController = try! "https://appdomain.com/color?rgb=239ddd".viewController()

PlaygroundPage.current.liveView = UINavigationController(rootViewController: rootViewController)

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    Navigate.push { $0
        .to("https://appdomain.com/other/CoreNavigation/john/doe")
    }
}
