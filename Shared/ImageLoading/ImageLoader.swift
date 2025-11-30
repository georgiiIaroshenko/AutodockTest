import Foundation

protocol ImageLoaderProtocol: AnyObject {
    func loadData(from url: URL) async throws -> Data
}

final class ImageLoader: ImageLoaderProtocol {
    private let loader: DataLoaderProtocol
    
    init(loader: DataLoaderProtocol) {
        self.loader = loader
    }
    
    func loadData(from url: URL) async throws -> Data {

        let request = ImageRequest(imageURL: url)

        let http = try await loader.load(request)
        return http.data
    }
}
