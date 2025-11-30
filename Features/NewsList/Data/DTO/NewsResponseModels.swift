import Foundation

nonisolated enum NewsItem: Hashable, Sendable {
    case news(NewsCellModel)
    
    var id: Int {
        switch self {
        case .news(let model):
            model.new.id
        }
    }
}

extension NewsItem {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    nonisolated static func == (lhs: NewsItem, rhs: NewsItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct News: Codable, Sendable {
    let news: [New]
    let totalCount: Int
}

extension News {
    init(_ newsDTO: NewsDTO) {
        self.news = newsDTO.news.map { New(newDTO: $0) }
        self.totalCount = newsDTO.totalCount
    }
}

struct New: Sendable,Codable {
    let id: Int
    let title: String
    let publishedDate: String
    let description: String
    let url: String
    let fullUrl: String
    let imageUrl: String?
    let categoryType: String
}

extension New: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: New, rhs: New) -> Bool {
        lhs.id == rhs.id
    }
}

extension New {
    init(newDTO: NewDTO) {
        self.id = newDTO.id
        self.title = newDTO.title
        self.description = newDTO.description
        self.publishedDate = DateFormatters.formatISODate(newDTO.publishedDate) ?? ""
        self.url = newDTO.url
        self.fullUrl = newDTO.fullUrl
        self.imageUrl = newDTO.titleImageUrl
        self.categoryType = newDTO.categoryType
    }
}
