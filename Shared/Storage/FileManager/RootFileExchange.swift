import Foundation

protocol RootFileExchangeProtocol: AnyObject {
    func write(_ data: Data, path: [String], filename: String) async throws
    func read(path: [String], filename: String) async -> Data?
    func remove(path: [String], filename: String) async
    func removeAll(in path: [String]) async
}

actor RootFileExchange: RootFileExchangeProtocol {
    
    private let fileManager = FileManager.default
    private let rootURL: URL
    
    init(rootFolder: String = "AutoDockTestProject") {
        let base = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let rootURL = base.appendingPathComponent(rootFolder, isDirectory: true)
        self.rootURL = rootURL
        try? fileManager.createDirectory(at: rootURL, withIntermediateDirectories: true)
        excludeFromBackup(url: rootURL)
    }
    
    func write(_ data: Data, path: [String], filename: String) async throws {
        let dir = path.reduce(rootURL) { $0.appendingPathComponent(safe($1), isDirectory: true) }
        if !fileManager.fileExists(atPath: dir.path) { try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true) }
        let url = dir.appendingPathComponent(safe(filename))
        try data.write(to: url, options: .atomic)
    }
    
    func read(path: [String], filename: String) async -> Data? {
        let dir = path.reduce(rootURL) { $0.appendingPathComponent(safe($1), isDirectory: true) }
        let url = dir.appendingPathComponent(safe(filename))
        return try? Data(contentsOf: url, options: .mappedIfSafe)
    }
    
    func remove(path: [String], filename: String) async {
        let dir = path.reduce(rootURL) { $0.appendingPathComponent(safe($1), isDirectory: true) }
        let url = dir.appendingPathComponent(safe(filename))
        try? fileManager.removeItem(at: url)
    }
    
    func removeAll(in path: [String]) async {
        let dir = path.reduce(rootURL) { $0.appendingPathComponent(safe($1), isDirectory: true) }
        try? fileManager.removeItem(at: dir)
        try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        excludeFromBackup(url: dir)
    }
}

private extension RootFileExchange {
    func safe(_ s: String) -> String {
        s.replacingOccurrences(of: "[^a-zA-Z0-9._-]", with: "_", options: .regularExpression)
    }
    
    func excludeFromBackup(url: URL) {
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        var u = url
        try? u.setResourceValues(values)
    }
}
