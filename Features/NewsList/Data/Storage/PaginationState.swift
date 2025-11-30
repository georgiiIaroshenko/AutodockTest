import Foundation

final class PaginationState {
    var page: Int
    let pageSize: Int
    var totalCount: Int
    var hasMore: Bool {
        page * pageSize < totalCount
    }
    
    init(page: Int, pageSize: Int, totalCount: Int) {
        self.page = page
        self.pageSize = pageSize
        self.totalCount = totalCount
    }

    func advance() {
        page += 1
    }
}
