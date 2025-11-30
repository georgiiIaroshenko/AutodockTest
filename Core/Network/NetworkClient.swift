import Foundation

// MARK: - NetworkClientProtocol

protocol NetworkClientProtocol {
    func send(request: URLRequest) async throws -> HTTPResult
}

// MARK: - NetworkClient

struct NetworkClient: NetworkClientProtocol, Sendable {
    
    // MARK: - Properties
    
    private let urlSession: URLSession

    // MARK: - Init
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    // MARK: - NetworkClientProtocol
    
    func send(request: URLRequest) async throws -> HTTPResult {
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpError = response as? HTTPURLResponse else { 
                print("❌ [NetworkClient] Invalid response type")
                throw NetworkClientError.http(status: -1, body: data) 
            }
            
            switch httpError.statusCode {
            case 200 ... 299:
                return HTTPResult(data: data, response: httpError)
            case 304:
                print("ℹ️ [NetworkClient] Resource not modified (304)")
                throw NetworkClientError.notModified
            case 429:
                let retryAfter = httpError.value(forHTTPHeaderField: "Retry-After").flatMap(Int.init)
                print("⚠️ [NetworkClient] Rate limited (429), retry after: \(retryAfter?.description ?? "unknown")")
                throw NetworkClientError.rateLimited(retryAfterSeconds: retryAfter)
            default:
                print("❌ [NetworkClient] HTTP error \(httpError.statusCode)")
                throw NetworkClientError.http(status: httpError.statusCode, body: data)
            }
        } catch let error as NetworkClientError {
            throw error
        } catch let error as URLError {
            print("❌ [NetworkClient] Transport error: \(error.localizedDescription)")
            throw NetworkClientError.transport(error)
        } catch {
            print("❌ [NetworkClient] Unexpected error: \(error.localizedDescription)")
            throw error
        }
    }
}

// MARK: - HTTPResult

struct HTTPResult {
    let data: Data
    let response: HTTPURLResponse
}


