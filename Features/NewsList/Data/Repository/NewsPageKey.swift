struct NewsPageKey: Hashable, CacheKeyProtocol {
    var key: String
    let pageSize: Int
}
