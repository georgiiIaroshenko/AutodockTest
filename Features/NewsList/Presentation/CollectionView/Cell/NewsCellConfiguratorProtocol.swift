import UIKit

protocol NewsCellConfiguratorProtocol: AnyObject {
    func canHandle(_ item: NewsItem, at indexPath: IndexPath) -> Bool

    func dequeueAndConfigure(
        in collectionView: UICollectionView,
        indexPath: IndexPath,
        item: NewsItem
    ) -> UICollectionViewCell
}
