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

    let searchBar = UISearchBar()

    static let headerSupplementaryView = "HeaderSupplementaryView"
    private static let searchReuseIdentifier = "SearchReuseIdentifier"
    private static let imageReuseIdentifier = "ImageCollectionCell"

    private let viewModel: ImageSearchViewModel
    private let imageService: ImageService

    private lazy var dataSource: ImageCollectionDataSource = buildDataSource()

    private static var columns: Int = 3
    private static var itemHeight: CGFloat = 150
    private static var itemInset: CGFloat = 4
    private static var itemSpacing: CGFloat = 4
    private static var lineSpacing: CGFloat = 4
    private static var contentInset: CGFloat = 16

    init(imageService: ImageService) {

        let viewModel = ImageSearchViewModel(imageService: imageService)
        self.viewModel = viewModel
        self.imageService = imageService

        let layout = Self.makeLayout()
        super.init(collectionViewLayout: layout)
        viewModel.dataSource = dataSource
        
        self.collectionView.backgroundColor = UIColor.white

        self.collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: Self.imageReuseIdentifier)
        self.collectionView.register(SearchHeader.self,
                                     forSupplementaryViewOfKind: Self.headerSupplementaryView,
                                     withReuseIdentifier: Self.searchReuseIdentifier)

        self.title = "Space Image Search"

        viewModel.showSearchError = { [weak self] error in
            self?.showSearchError(error)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func makeLayout() -> UICollectionViewLayout {

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
            heightDimension: .absolute(70.0)
        )
        let searchHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Self.headerSupplementaryView,
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

        let dataSource = ImageCollectionDataSource(collectionView: self.collectionView) { [weak self] (collectionView, indexPath, spaceImage) -> UICollectionViewCell? in
            guard let self else {
                return nil
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.imageReuseIdentifier, for: indexPath) as! ImageCollectionViewCell
            cell.title.text = "\(spaceImage.title)"
            cell.previewUrl = spaceImage.thumbnail
            cell.fetchImage = self.viewModel.fetchImage
            return cell
        }

        dataSource.supplementaryViewProvider = { [weak self] (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            guard let self else {
                return nil
            }

            let searchHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: Self.headerSupplementaryView,
                withReuseIdentifier: Self.searchReuseIdentifier,
                for: indexPath) as? SearchHeader
            searchHeader?.searchField.delegate = viewModel
            searchHeader?.categoryPicker.selectedSegmentIndex = viewModel.searchTopic?.rawValue ?? 0
            searchHeader?.categoryPicker.addTarget(viewModel, action: #selector(ImageSearchViewModel.topicSelected(sender:)), for: .valueChanged)


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
}
