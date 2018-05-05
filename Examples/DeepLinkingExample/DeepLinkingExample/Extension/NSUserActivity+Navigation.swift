import Foundation
import CoreNavigation

extension NSUserActivity {
    enum Error: Swift.Error {
        case unprocessableEntity
    }
    
    func navigate() throws {
        guard
            activityType == NSUserActivityTypeBrowsingWeb,
            let url = webpageURL
            else {
                throw Error.unprocessableEntity
            }
    
        Navigate.push { $0
            .to(url)
            .animated(false)
            .onSuccess({ (result) in
                let color = result.data as? UIColor
                print("Did open deep link url: \(url), data: \(color!)")
            })
        }
    }
    
}
