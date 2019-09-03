extension Caching {
    public enum CachingType {
        case timeInterval(TimeInterval)
        case block((Caching.Context) -> Void)
    }
}
