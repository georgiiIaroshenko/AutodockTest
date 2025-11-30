import Foundation

protocol DataLoaderProtocol: AnyObject  {
    func load<R: RequestProtocol>(_ request: R) async throws -> HTTPResult
}

final class DataLoader: DataLoaderProtocol {
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
    
    func load<R: RequestProtocol>(_ request: R) async throws -> HTTPResult {
        guard let valideR = request.makeRequest() else { throw DataLoaderError.invalideRequest }
        return try await client.send(request: valideR )
    }
}

enum DataLoaderError: Error {
    case invalideRequest
}
