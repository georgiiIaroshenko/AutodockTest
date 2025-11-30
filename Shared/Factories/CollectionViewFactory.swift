import UIKit
protocol CollectionViewFactoryProtocol: AnyObject {
    func make(layoutProvider: NewsLayoutProvidingProtocol) -> UICollectionView
}

final class CollectionViewFactory: CollectionViewFactoryProtocol {
    func make(layoutProvider: NewsLayoutProvidingProtocol) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutProvider.makeLayout())
        return collectionView
    }
}
