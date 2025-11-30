struct NewsDTO: Decodable, Sendable {
    let news: [NewDTO]
    let totalCount: Int
}
