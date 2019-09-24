extension Caching {
    public enum CachingType {
        case timeInterval(TimeInterval)
        case expirationDate(Date)
        case block((Caching.Context) -> Void)
    }
}
