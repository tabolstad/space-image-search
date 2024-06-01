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
    var showSearchError: ((Error) -> Void)?

    private var imageService: ImageService

    private let debounceTime: UInt64 = 500_000_000
    private var searchQuery: String = ""
    private var searchTask: Task<Void, any Error>?
    var searchTopic: SearchTopic? = .title

    init(imageService: ImageService) {
        self.imageService = imageService
        super.init()
        updateSnapshot(animatingChange: false)
    }

    func updateSnapshot(animatingChange: Bool) {
        searchTask?.cancel()
        searchTask = nil
        let newSearch = Task {
            try await Task.sleep(nanoseconds: debounceTime)
            do {
                let images = try await imageService.search(query: searchQuery, searchTopic: searchTopic)
                await replaceImages(images, animatingChange: true)
            } catch {
                showSearchError?(error)
            }
        }
        searchTask = newSearch
    }

    @MainActor
    private func replaceImages(_ images: [SpaceImage], animatingChange: Bool) {
        var snapshot = ImageDataSourceSnapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(images, toSection: .all)

        dataSource?.apply(snapshot, animatingDifferences: animatingChange)
    }

    @MainActor
    private func appendImages(_ images: [SpaceImage], animatingChange: Bool) {
        var snapshot = ImageDataSourceSnapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(images, toSection: .all)

        dataSource?.apply(snapshot, animatingDifferences: animatingChange)
    }

    func fetchImage(url: URL) async throws -> UIImage {
        return try await imageService.fetchImage(url: url)
    }

    @objc
    func topicSelected(sender: AnyObject) {
        if let sender = sender as? UISegmentedControl,
           let topic = SearchTopic(rawValue: sender.selectedSegmentIndex) {
            searchTopic = topic
        } else {
            searchTopic = nil
        }
    }
}

extension ImageSearchViewModel: UISearchTextFieldDelegate, UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let newQuery = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard newQuery != searchQuery else {
            return
        }
        searchQuery = newQuery ?? ""
        updateSnapshot(animatingChange: true)
    }
}
