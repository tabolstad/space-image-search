//
//  ImageSearchViewModel.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import UIKit

typealias ImageCollectionDataSource = UICollectionViewDiffableDataSource<ImageSearchViewController.Section, SpaceImage>
typealias ImageDataSourceSnapshot = NSDiffableDataSourceSnapshot<ImageSearchViewController.Section, SpaceImage>

final class ImageSearchViewModel: NSObject {

    var dataSource: ImageCollectionDataSource?
    var searchTopic: SearchTopic? = .title
    var showSearchError: ((Error) -> Void)?

    private var imageService: ImageService

    // Search
    private let searchDebounceTime: UInt64 = 500_000_000
    private var searchQuery: String = ""
    private var searchTask: Task<Void, any Error>?
    // Pagination
    private var currentImages: [SpaceImage] = []
    private var nextPage: URL?
    private var totalFoundCount: Int = 0

    init(imageService: ImageService) {
        self.imageService = imageService
        super.init()
        clearImages(animatingChange: false)
    }

    func loadNextPage() {
        guard let nextPage else {
            return
        }
        Task {
            let batch = try await self.imageService.fetchNextPage(url: nextPage)
            await appendImages(batch, animatingChange: true)
        }
    }

    private func performSearchTask(query: String,
                                   topic: SearchTopic?,
                                   animatingChange: Bool) {

        searchTask?.cancel()
        searchTask = nil
        
        let newSearch = Task {
            try await Task.sleep(nanoseconds: searchDebounceTime)
            do {
                let batch = try await imageService.search(query: query, searchTopic: topic)
                await replaceImages(batch, animatingChange: true)
            } catch {
                showSearchError?(error)
            }
        }
        searchTask = newSearch
    }


    private func clearImages(animatingChange: Bool = true) {

        currentImages = []
        totalFoundCount = 0
        nextPage = nil
        Task {
            await applySnapshot(images: currentImages, animatingChange: animatingChange)
        }
    }

    @MainActor
    private func replaceImages(_ imageBatch: ImageBatch, animatingChange: Bool) {

        currentImages = imageBatch.images
        totalFoundCount = imageBatch.totalCount
        nextPage = imageBatch.next
        applySnapshot(images: currentImages, animatingChange: animatingChange)
    }


    @MainActor
    private func appendImages(_ imageBatch: ImageBatch, animatingChange: Bool) {

        currentImages.append(contentsOf: imageBatch.images)
        totalFoundCount = imageBatch.totalCount
        nextPage = imageBatch.next
        applySnapshot(images: currentImages, animatingChange: animatingChange)
    }

    @MainActor
    private func applySnapshot(images: [SpaceImage], animatingChange: Bool) {
        
        var snapshot = ImageDataSourceSnapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(images, toSection: .all)
        dataSource?.apply(snapshot, animatingDifferences: animatingChange)
    }

    func fetchImage(url: URL) async throws -> UIImage {
        return try await imageService.fetchImage(url: url)
    }

    @objc
    func searchTopicSelected(sender: AnyObject) {
        if let sender = sender as? UISegmentedControl,
           let topic = SearchTopic(rawValue: sender.selectedSegmentIndex) {
            searchTopic = topic
        } else {
            searchTopic = nil
        }
        clearImages()
    }
}

extension ImageSearchViewModel: UISearchTextFieldDelegate, UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let newQuery = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard newQuery != searchQuery else {
            return
        }
        guard let newQuery else {
            return
        }
        if newQuery == "" {
            clearImages()
            return
        }
        searchQuery = newQuery
        performSearchTask(query: newQuery,
                          topic: searchTopic,
                          animatingChange: true)
    }
}
