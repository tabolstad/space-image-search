//
//  ImageSearchViewController+Layout.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 6/2/24.
//

import UIKit

// MARK: - Collection View Compositional Layout

extension ImageSearchViewController {

    private static var columns: Int = 3
    private static var itemFractionalHeight: CGFloat = 1.0 / 5.0
    private static var itemSpacing: CGFloat = 6
    private static var lineSpacing: CGFloat = 0
    private static var contentInset: CGFloat = 16

    private static let headerSupplementaryViewKind = "HeaderSupplementaryView"
    private static let searchHeaderReuseIdentifier = "SearchReuseIdentifier"
    private static let imageCellReuseIdentifier = "ImageCollectionCell"

    func registerCollectionViewItems() {
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: Self.imageCellReuseIdentifier)

        collectionView.register(SearchHeader.self,
                                forSupplementaryViewOfKind: Self.headerSupplementaryViewKind,
                                withReuseIdentifier: Self.searchHeaderReuseIdentifier)
    }

    static func makeLayout() -> UICollectionViewLayout {

        // Image Items
        let itemSize = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0 / CGFloat(columns)),
            heightDimension: NSCollectionLayoutDimension.uniformAcrossSiblings(estimate: 500)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: NSCollectionLayoutDimension.fractionalHeight(itemFractionalHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: columns)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(itemSpacing)

        // Search Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let searchHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Self.headerSupplementaryViewKind,
            alignment: .top
        )
        searchHeader.pinToVisibleBounds = true

        // Configure Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = lineSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: contentInset,
                                                        leading: contentInset,
                                                        bottom: contentInset,
                                                        trailing: contentInset)
        section.boundarySupplementaryItems = [searchHeader]

        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(
            section: section,
            configuration: config
        )
        return layout
    }

    func buildDataSource() -> ImageCollectionDataSource {

        // Images
        let dataSource = ImageCollectionDataSource(collectionView: collectionView) { [weak self] (
            collectionView,
            indexPath,
            spaceImage) -> UICollectionViewCell? in

            guard let self else {
                return nil
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.imageCellReuseIdentifier, for: indexPath) as! ImageCollectionViewCell
            cell.title.text = "\(spaceImage.title)"
            cell.previewUrl = spaceImage.thumbnail
            cell.fetchImage = self.viewModel.fetchImage
            return cell
        }

        // Header View
        dataSource.supplementaryViewProvider = { [weak self] (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            guard let self else {
                return nil
            }

            let searchHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: Self.headerSupplementaryViewKind,
                withReuseIdentifier: Self.searchHeaderReuseIdentifier,
                for: indexPath
            ) as? SearchHeader
            searchHeader?.searchField.delegate = viewModel
            searchHeader?.categoryPicker.selectedSegmentIndex = viewModel.searchTopic?.rawValue ?? 0
            searchHeader?.categoryPicker.addTarget(viewModel, action: #selector(ImageSearchViewModel.searchTopicSelected(sender:)), for: .valueChanged)
            viewModel.updateSearchPlacehoder = { searchPlaceholderString in
                searchHeader?.searchPlaceholder = searchPlaceholderString
            }

            viewModel.updateSearchField = { searchString in
                searchHeader?.searchString = searchString
            }

            return searchHeader
        }
        return dataSource
    }
}
