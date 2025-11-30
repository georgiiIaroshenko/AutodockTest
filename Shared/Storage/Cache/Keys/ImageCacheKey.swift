import Foundation

struct ImageCacheKey: Hashable {
    let url: String
    let size: CGSize
}
extension ImageCacheKey {
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

extension ImageCacheKey: CacheKeyProtocol {
    var key: String {
        let safeID = url
            .replacingOccurrences(of: "[^A-Za-z0-9._-]", with: "_", options: .regularExpression)
        return "\(safeID)#\(size)"
    }
}
