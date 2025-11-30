struct CacheLimit {
    let totalCostLimit: Int
    let countLimit: Int

    init(
        totalCostLimit: Int = 50 * 1024 * 1024,
        countLimit: Int = 100
    ) {
        self.totalCostLimit = totalCostLimit
        self.countLimit = countLimit
    }
}
