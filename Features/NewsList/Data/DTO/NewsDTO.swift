struct NewDTO: Decodable, Sendable {
    let id: Int
    let title: String
    let publishedDate: String
    let description: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String?
    let categoryType: String
}
