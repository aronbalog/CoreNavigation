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
            .completion {
                print("Did open deep link url: ", url)
            }
        }
    }
    
}
