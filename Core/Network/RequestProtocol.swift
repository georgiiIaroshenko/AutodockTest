import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol RequestProtocol {
    associatedtype Response
    func makeRequest() -> URLRequest?
}

protocol ApiRequestProtocol: RequestProtocol where Response: Decodable {

    var settingAPI: SettingAPI { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

extension ApiRequestProtocol {
    var method: HTTPMethod { .get }
    var parameters: [URLQueryItem]? { nil }
    var headers: [String: String]? { ["Accept": "application/json"] }
    var body: Data? { nil }

    func makeRequest() -> URLRequest? {
        var comps = URLComponents()
        comps.scheme = settingAPI.scheme
        comps.host   = settingAPI.host
        let endpoint = settingAPI.endpoint
        comps.path   = endpoint + (path.hasPrefix("/") ? path : "/" + path)
        comps.queryItems = parameters

        guard let url = comps.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody   = body
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
