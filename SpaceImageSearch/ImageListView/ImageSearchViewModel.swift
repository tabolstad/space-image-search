//
//  ImageSearchViewModel.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import UIKit

typealias ImageCollectionDataSource = UICollectionViewDiffableDataSource<ImageSearchViewController.Section, SpaceImage>
typealias ImageDataSourceSnapshot = NSDiffableDataSourceSnapshot<ImageSearchViewController.Section, SpaceImage>

final class ImageSearchViewModel {

    private var imageService: ImageService

    var searchQuery: String = ""
    var dataSource: ImageCollectionDataSource?

    init(imageService: ImageService) {
        self.imageService = imageService
        updateSnapshot(animatingChange: false)
    }

    func updateSnapshot(animatingChange: Bool = false) {
        Task {
            let images = try await imageService.search(query: searchQuery)
            Task { @MainActor in
                var snapshot = ImageDataSourceSnapshot()
                snapshot.appendSections([.all])
                snapshot.appendItems(images, toSection: .all)

                dataSource?.apply(snapshot, animatingDifferences: false)
            }
        }
    }

    func fetchImage(url: URL) async throws -> UIImage {
        return try await imageService.fetchImage(url: url)
    }
}
