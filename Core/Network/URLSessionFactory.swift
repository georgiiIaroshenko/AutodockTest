import Foundation

protocol NewsURLSession {
    func makeNewsURLSession() -> URLSession
}

protocol ImageURLSessionProtocol {
    func makeImageURLSession() -> URLSession
}

struct URLSessionFactory: NewsURLSession, ImageURLSessionProtocol {
    func makeNewsURLSession() -> URLSession {
        let urlCache = URLCache(
            memoryCapacity: 25 * 1024 * 1024,
            diskCapacity: 50 * 1024 * 1024)
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = urlCache
        configuration.requestCachePolicy = .useProtocolCachePolicy

        return URLSession(configuration: configuration)
    }

    func makeImageURLSession() -> URLSession {
        URLSession(configuration: .default)
    }
}
