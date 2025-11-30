import Foundation

// MARK: - NetworkClientError

enum NetworkClientError: Error, LocalizedError {
    case rateLimited(retryAfterSeconds: Int?)
    case transport(URLError)
    case notModified
    case http(status: Int, body: Data)
    
    var errorDescription: String? {
        switch self {
        case let .rateLimited(retryAfter):
            if let retryAfter {
                return "Request was rate limited. Retry after \(retryAfter) seconds."
            } else {
                return "Request was rate limited."
            }
        case let .transport(error):
            return "Network transport error: \(error.localizedDescription)"
        case .notModified:
            return "Resource not modified (304)."
        case let .http(status, _):
            return "HTTP error with status code \(status)."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .rateLimited:
            return "Too many requests sent in a short time period."
        case let .transport(error):
            return error.localizedDescription
        case .notModified:
            return "The requested resource has not been modified since the last request."
        case let .http(status, _):
            return "Server responded with HTTP status code \(status)."
        }
    }
}
