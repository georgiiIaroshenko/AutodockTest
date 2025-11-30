protocol CacheProtocol: AnyObject {
    associatedtype Value
    func get(_ key: CacheKeyProtocol) -> Value?
    func set(_ value: Value, for key: CacheKeyProtocol)
    func remove(_ key: CacheKeyProtocol)
    func removeAll()
}
