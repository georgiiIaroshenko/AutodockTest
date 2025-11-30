import UIKit

final class MainNewsCellConfigurator: NewsCellConfiguratorProtocol {
    
    private let imageLoader: SingleImageLoadingProtocol
    private let layoutProvider: NewsLayoutProvidingProtocol
    private let registration: UICollectionView.CellRegistration<NewsMainCell, NewsItem>
    
    init(imageLoader: SingleImageLoadingProtocol, layoutProvider: NewsLayoutProvidingProtocol) {
        self.imageLoader = imageLoader
        self.layoutProvider = layoutProvider
        
        self.registration = UICollectionView.CellRegistration<NewsMainCell, NewsItem> { [weak imageLoader, weak layoutProvider] cell, indexPath, item in
            guard let imageLoader, let layoutProvider else { return }
            guard case let .news(model) = item else { return }
            
            let width = cell.bounds.width
            let trait = cell.traitCollection
            let imageSize = layoutProvider.imageSize(for: width, trait: trait)
            
            cell.contentConfiguration = NewsContentConfiguration(
                content: model,
                imageLoader: imageLoader,
                imageSize: imageSize
            )
        }
    }
    
    func canHandle(_ item: NewsItem, at indexPath: IndexPath) -> Bool {
        if case .news = item { return true }
        return false
    }
    
    func dequeueAndConfigure(
        in collectionView: UICollectionView,
        indexPath: IndexPath,
        item: NewsItem
    ) -> UICollectionViewCell {
        return collectionView.dequeueConfiguredReusableCell(
            using: registration,
            for: indexPath,
            item: item
        )
    }
}
