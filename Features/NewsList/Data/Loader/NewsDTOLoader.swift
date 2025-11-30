import Foundation
protocol NewsDTOLoaderProtocol: AnyObject {
    func loadData(page: Int, pageSize: Int) async throws -> Data
}

final class NewsDTOLoader: NewsDTOLoaderProtocol {
    private let loader: DataLoaderProtocol
    
    init(loader: DataLoaderProtocol) {
        self.loader = loader
    }
    
    func loadData(page: Int, pageSize: Int) async throws -> Data {
        let request = NewsDTORequest(page: page, pageSize: pageSize)
        let http = try await loader.load(request)
        return http.data
    }
}
