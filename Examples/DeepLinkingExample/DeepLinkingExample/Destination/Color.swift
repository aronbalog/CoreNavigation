import Foundation
import CoreNavigation

struct Color: Destination {
    typealias ViewControllerType = ColorViewController
    
    static func resolve(context: Context<ViewControllerType>) {
        guard let rgbHexString = context.parameters?["color"] as? String else {
            context.complete()
            return
        }
        
        let color = UIColor(hexString: rgbHexString)
        
        context.complete(data: color)
    }
}

