import Foundation

struct ImageRequest: RequestProtocol {
    typealias Response = Data

    private let imageURL: URL

    init(imageURL: URL) {
        self.imageURL = imageURL
    }

    func makeRequest() -> URLRequest? {
        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"
        return request
    }
}
