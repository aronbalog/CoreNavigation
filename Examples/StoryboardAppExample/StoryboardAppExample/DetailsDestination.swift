import CoreNavigation

struct DetailsDestination: Destination, Protectable {
    let auth = Auth()
    
    typealias ViewControllerType = DetailsViewController
    
    func protect(with context: Protection.Context) throws {
        try auth.protect(with: context)
    }
}
