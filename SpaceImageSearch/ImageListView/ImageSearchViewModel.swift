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

    private var imageService: ImageService

    var dataSource: ImageCollectionDataSource?
    var showSearchError: ((Error) -> Void)?
    var updateSearchPlacehoder: ((String) -> Void)?
    var updateSearchField: ((String) -> Void)?
    var updateContentForResults: (() -> Void)?

    // Search
    var searchQuery: String = ""
    var searchTopic: SearchTopic? {
        didSet {
            didUpdateSearchTopic()
        }
    }
    private var searchTask: Task<Void, Never>?
    // Pagination
    var currentImages: [SpaceImage] = [] {
        didSet {
            updateContentForResults?()
        }
    }
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

        searchTask?.cancel()
        searchTask = nil
        
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

        guard !imageBatch.images.isEmpty else {
            return
        }

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

    private func didUpdateSearchTopic() {
        clearImages()
        searchQuery = ""
        updateSearchField?(searchQuery)

        let placeholder = switch searchTopic {
        case .title:
            "SearchHeader.Placeholder.Title".localized
        case .photographer:
            "SearchHeader.Placeholder.Photo".localized
        case .location:
            "SearchHeader.Placeholder.Location".localized
        case nil:
            "SearchHeader.Placeholder.Default".localized
        }
        updateSearchPlacehoder?(placeholder)
    }
}

extension ImageSearchViewModel: UISearchTextFieldDelegate, UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let newQuery = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let newQuery else {
            return false
        }
        guard newQuery != searchQuery else {
            return false
        }
        searchQuery = newQuery
        if newQuery == "" {
            clearImages()
            return false
        }
        performSearchTask(query: newQuery,
                          topic: searchTopic,
                          animatingChange: true)
        return true
    }
}
