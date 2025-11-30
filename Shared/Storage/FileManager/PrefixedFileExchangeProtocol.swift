import Foundation

protocol _PrefixedFileExchangeInternals: AnyObject  {
    var exchange: RootFileExchangeProtocol { get }
    var basePath: [String] { get }
}

protocol PrefixedFileExchangeProtocol: AnyObject  {
    func write(_ data: Data, filename: String) async throws
    func read(filename: String) async -> Data?
    func remove(filename: String) async
    func removeAll() async
}

extension PrefixedFileExchangeProtocol where Self: _PrefixedFileExchangeInternals {
    func write(_ data: Data, filename: String) async throws {
        try await exchange.write(data, path: basePath, filename: filename)
    }
    
    func read(filename: String) async -> Data? {
        await exchange.read(path: basePath, filename: filename)
    }
    
    func remove(filename: String) async {
        await exchange.remove(path: basePath, filename: filename)
    }
    
    func removeAll() async {
        await exchange.removeAll(in: basePath)
    }
}
