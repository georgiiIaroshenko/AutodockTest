import Foundation

// MARK: - NewsServiceProtocol

protocol NewsServiceProtocol: AnyObject {
    func loadFirst() async throws -> [New]
    func loadNext() async throws -> [New]
}

// MARK: - NewsService

final class NewsService: NewsServiceProtocol {
    
    // MARK: - Properties
    
    private let repository: NewsRepositoryProtocol
    private var isLoadingNextPage = false
    private var pagination = PaginationState(page: 1, pageSize: 15, totalCount: 0)
    private var loadedIDs = Set<Int>()
    
    // MARK: - Init
    
    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    func loadFirst() async throws -> [New] {
        do {
            let page = try await repository.getNewsPage(page: pagination.page, pageSize: pagination.pageSize)
            pagination.totalCount = page.totalCount
            let uniques = filterUnique(page.news)
            
            print("✅ [NewsService] Loaded first page: \(uniques.count) news items (total: \(page.totalCount))")
            return uniques
        } catch {
            print("❌ [NewsService] Failed to load first page: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadNext() async throws -> [New] {
        guard !isLoadingNextPage else { 
            print("⚠️ [NewsService] Already loading next page")
            throw NewsServiceError.alreadyLoading 
        }
        guard pagination.hasMore else {
            print("ℹ️ [NewsService] No more news to load")
            throw NewsServiceError.noMoreNews
        }
        
        isLoadingNextPage = true
        defer { isLoadingNextPage = false }
        
        do {
            let nextPage = pagination.page + 1
            let page = try await repository.getNewsPage(page: nextPage, pageSize: pagination.pageSize)
            
            pagination.page = nextPage
            pagination.totalCount = page.totalCount
            let uniques = filterUnique(page.news)
            
            print("✅ [NewsService] Loaded page \(nextPage): \(uniques.count) new items")
            return uniques
        } catch {
            print("❌ [NewsService] Failed to load page \(pagination.page + 1): \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Private Methods
    
    private func filterUnique(_ news: [New]) -> [New] {
        news.filter { loadedIDs.insert($0.id).inserted }
    }
}

// MARK: - NewsServiceError

enum NewsServiceError: Error, LocalizedError {
    case alreadyLoading
    case noMoreNews
    
    var errorDescription: String? {
        switch self {
        case .alreadyLoading:
            return "A page load is already in progress."
        case .noMoreNews:
            return "No more news available to load."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .alreadyLoading:
            return "Cannot start a new page load while another is in progress."
        case .noMoreNews:
            return "All available news items have been loaded."
        }
    }
}
