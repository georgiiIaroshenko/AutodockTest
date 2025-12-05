import Foundation
// MARK: - InflightTable

final class InflightTable<Key: Hashable, Value: Sendable>: Sendable {
    
    private let lock = NSLock()
    private var tasks: [Key: Task<Value, Error>] = [:]
    // MARK: - Public Methods

    func run(key: Key, operation: @Sendable @escaping () async throws -> Value) async throws -> Value {
        
        lock.lock()
        if let existing = tasks[key] {
            lock.unlock()
            return try await existing.value
        }
        
        let task = Task<Value, Error>(priority: .userInitiated) {
            try await operation()
        }
        tasks[key] = task
        lock.unlock()
        
        defer {
            lock.lock()
            tasks[key] = nil
            lock.unlock()
        }
        
        return try await task.value
    }
}
// MARK: - Cancellation

    extension InflightTable {

    func cancel(for key: Key) {
        lock.lock()
        defer { lock.unlock() }
        tasks[key]?.cancel()
        tasks.removeValue(forKey: key)
    }
    
    func cancelAll() {
        lock.lock()
        defer { lock.unlock() }
        tasks.values.forEach { $0.cancel() }
        tasks.removeAll()
    }
}
