import UIKit

protocol NewsLayoutProvidingProtocol: AnyObject {
    var columns: Int { get }
    var portretСolumns: Int { get }
    func makeLayout() -> UICollectionViewCompositionalLayout
    func imageSize(for containerWidth: CGFloat,
                       trait: UITraitCollection) -> CGSize
}

extension NewsLayoutProvidingProtocol {
    func imageSize(
        for containerWidth: CGFloat,
        trait: UITraitCollection
    ) -> CGSize {
        let horizontalInsets: CGFloat = 24
        let interItemSpacing: CGFloat = 6

        let totalSpacing = interItemSpacing * CGFloat(max(columns - 1, 0))
        let available = containerWidth - horizontalInsets - totalSpacing
        let width = floor(available / CGFloat(columns))

        let aspect: CGFloat = 9.0 / 16.0
        let height = width * aspect

        return CGSize(width: width, height: height)
    }
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] _, environment in
            guard let self else { return nil }
            let containerWidth = environment.container.effectiveContentSize.width
                    let trait = environment.traitCollection
            
            let column: Int
            if trait.horizontalSizeClass == .compact {
                column = self.columns
            } else {
                column = self.portretСolumns
            }
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(330)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(330)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: column
            )
            group.interItemSpacing = .fixed(6)
            
            let section = NSCollectionLayoutSection(group: group)
            
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(60)
            )
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: LoadingFooterView.elementKind,
                alignment: .bottom
            )
            
            section.boundarySupplementaryItems = [footer]
            
            return section
        }
    }
}
