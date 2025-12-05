import Combine
import UIKit

// MARK: - NewsViewModel Protocols

protocol NewsViewModelGetNewsProtocol: AnyObject {
    func getNews() async throws
    func getNextPageNews() async throws
    func prefetchNextPageNews()
}

protocol NewsViewModelSubjects: AnyObject {
    var news: AnyPublisher<[NewsSectionModel], Never> { get }
}

protocol NewsViewRoutingProtocol: AnyObject {
    func didSelect(item: NewsItem)
}

protocol NewsViewModelProtocol: NewsViewModelSubjects, NewsViewModelGetNewsProtocol, NewsViewRoutingProtocol {
    var imageService: SingleImageLoadingProtocol { get }
}

// MARK: - NewsViewModel

final class NewsViewModel: NewsViewModelProtocol {
    
    // MARK: - Properties
    
    private let newsService: NewsServiceProtocol
    let imageService: SingleImageLoadingProtocol
    private let router: NewsRoutingProtocol
    
    private let newsSubject = CurrentValueSubject<[NewsSectionModel], Never>([])
    var news: AnyPublisher<[NewsSectionModel], Never> { newsSubject.eraseToAnyPublisher() }
    
    // MARK: - Init
    
    init(newsService: NewsServiceProtocol, imageService: ImageServiceProtocol, router: NewsRoutingProtocol) {
        self.newsService = newsService
        self.imageService = imageService
        self.router = router
    }
    
    // MARK: - NewsViewModelGetNewsProtocol
    
    func getNews() async throws {
        do {
            let news = try await newsService.loadFirst()

            let items = news.map {
                NewsItem.news(
                    NewsCellModel(new: $0)
                )
            }

            let section = NewsSectionModel(section: .main, items: items)
            newsSubject.send([section])
        } catch {
            print("❌ [NewsViewModel] Error loading first page: \(error.localizedDescription)")
            throw error
        }
    }

    func getNextPageNews() async throws {
        do {
            let news = try await newsService.loadNext()
            guard !news.isEmpty else { throw NewsViewModelError.noMoreNews }

            let currentSections = newsSubject.value
            let (updatedSections, _) = mergedSections(
                oldSections: currentSections,
                newNews: news
            )

            newsSubject.send(updatedSections)
        } catch let error as NewsServiceError {
            print("ℹ️ [NewsViewModel] News service error: \(error.errorDescription ?? "Unknown")")
            throw error
        } catch {
            print("❌ [NewsViewModel] Error loading next page: \(error.localizedDescription)")
            throw error
        }
    }
    
    func prefetchNextPageNews() {
        Task(priority: .background) {
           try await newsService.prefetchNext()
        }
    }
    
    // MARK: - NewsViewRoutingProtocol
    
    func didSelect(item: NewsItem) {
        switch item {
        case .news(let newCell):
            router.showDetail(newCell.new)
        default:
            fatalError()
        }
    }
    
    // MARK: - Private Methods
    
    private func mergedSections(
        oldSections: [NewsSectionModel],
        newNews: [New]
    ) -> (sections: [NewsSectionModel], newItems: [NewsItem]) {
        var sections = oldSections

        let existingIDs = Set(
            sections
                .flatMap { $0.items }
                .compactMap { item -> Int? in
                    guard case let .news(model) = item else { return nil }
                    return model.new.id
                }
        )

        let uniqueNews = newNews.filter { !existingIDs.contains($0.id) }

        let newItems = uniqueNews.map {
            NewsItem.news(
                NewsCellModel(new: $0)
            )
        }

        if let index = sections.firstIndex(where: { $0.section == .main }) {
            sections[index].items.append(contentsOf: newItems)
        } else {
            sections.append(NewsSectionModel(section: .main, items: newItems))
        }

        return (sections, newItems)
    }
}

// MARK: - NewsViewModelError

enum NewsViewModelError: Error, LocalizedError {
    case noMoreNews
    
    var errorDescription: String? {
        switch self {
        case .noMoreNews:
            return "No more news items to display."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .noMoreNews:
            return "The service returned an empty array of news."
        }
    }
}
