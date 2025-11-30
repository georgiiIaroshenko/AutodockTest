// MARK: - InflightTable

actor InflightTable<Key: Hashable, Value> {
    
    // MARK: - Properties
    
    private var tasks: [Key: Task<Value, Error>] = [:]
    
    // MARK: - Public Methods
    
    func run(key: Key, operation: @escaping () async throws -> Value) async throws -> Value {
        if let existing = tasks[key] {
            return try await existing.value
        }
        let task = Task(priority: .utility) {
            try await operation()
        }
        tasks[key] = task
        defer { tasks[key] = nil }
        return try await task.value
    }
}

// MARK: - Cancellation

extension InflightTable {
    
    func cancelAll() async {
        for (_, task) in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }
    
    func cancel(for key: Key) async {
        if let task = tasks[key] {
            task.cancel()
            tasks.removeValue(forKey: key)
        }
    }
}
