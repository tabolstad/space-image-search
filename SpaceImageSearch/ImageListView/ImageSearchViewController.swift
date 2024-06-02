//
//  ImageSearchViewController.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import UIKit

final class ImageSearchViewController: UICollectionViewController {

    enum Section {
        case all
    }

    private static let headerSupplementaryViewKind = "HeaderSupplementaryView"
    private static let searchHeaderReuseIdentifier = "SearchReuseIdentifier"
    private static let imageCellReuseIdentifier = "ImageCollectionCell"

    private static var columns: Int = 3
    private static var itemHeight: CGFloat = 150
    private static var itemSpacing: CGFloat = 4
    private static var lineSpacing: CGFloat = 4
    private static var contentInset: CGFloat = 16

    let searchBar = UISearchBar()

    private let viewModel: ImageSearchViewModel
    private let imageService: ImageService

    private lazy var dataSource: ImageCollectionDataSource = buildDataSource()

    init(imageService: ImageService) {

        let viewModel = ImageSearchViewModel(imageService: imageService)
        self.viewModel = viewModel
        self.imageService = imageService

        let layout = Self.makeLayout()
        super.init(collectionViewLayout: layout)

        viewModel.dataSource = dataSource
        
        collectionView.backgroundColor = UIColor(named: "ViewBackground")

        collectionView.register(ImageCollectionViewCell.self, 
                                forCellWithReuseIdentifier: Self.imageCellReuseIdentifier)

        collectionView.register(SearchHeader.self,
                                forSupplementaryViewOfKind: Self.headerSupplementaryViewKind,
                                withReuseIdentifier: Self.searchHeaderReuseIdentifier)

        title = "Space Image Search"

        viewModel.showSearchError = { [weak self] error in
            self?.showSearchError(error)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func makeLayout() -> UICollectionViewLayout {

        // Image Items
        let itemSize = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0 / CGFloat(columns)),
            heightDimension: NSCollectionLayoutDimension.uniformAcrossSiblings(estimate: itemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: NSCollectionLayoutDimension.uniformAcrossSiblings(estimate: itemHeight)
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

    private func buildDataSource() -> ImageCollectionDataSource {

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

            return searchHeader
        }
        return dataSource
    }

    private func showSearchError(_ error: Error) {
        let alert = UIAlertController(
            title: "Search Error",
            message: "An error in search occurred: \(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        Task { @MainActor in
            present(alert, animated: true)
        }
    }
}

extension ImageSearchViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let selectedImage = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        var thumbnail: UIImage?
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            thumbnail = cell.preview.image
        }

        let detailViewController = ImageDetailViewController(
            spaceImage: selectedImage,
            imageService: imageService,
            thumbnail: thumbnail
        )
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if isLastImage(collectionView, indexPath: indexPath) {
            viewModel.loadNextPage()
        }
    }

    private func isLastImage(_ collectionView: UICollectionView, indexPath: IndexPath) -> Bool {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastItemIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        let lastIndex =  IndexPath(item: lastItemIndex, section: lastSectionIndex)
        return indexPath == lastIndex
    }
}
