import Foundation

struct NewsCellModel: Hashable, Sendable {
    let new: New
}

extension NewsCellModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(new)
    }
}
