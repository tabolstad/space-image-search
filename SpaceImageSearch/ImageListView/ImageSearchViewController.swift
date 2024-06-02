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

    let viewModel: ImageSearchViewModel
    private let imageService: ImageService
    private var noResultsView: NoResultsMessageView?
    var searchHeader: SearchHeader?

    private lazy var dataSource: ImageCollectionDataSource = buildDataSource()

    init(imageService: ImageService) {

        let viewModel = ImageSearchViewModel(imageService: imageService)
        self.viewModel = viewModel
        self.imageService = imageService

        let layout = Self.makeLayout()
        super.init(collectionViewLayout: layout)

        title = "SearchScreen.Title".localized
        collectionView.backgroundColor = UIColor.viewBackground

        registerCollectionViewItems()

        viewModel.dataSource = dataSource
        viewModel.showSearchError = { [weak self] error in
            self?.showSearchError(error)
        }
        viewModel.updateContentForResults = { [weak self] in
            self?.updateContentForResult()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            // We need to wait until the collection view is loaded.
            // Otherwise the header will not get set.
            self.viewModel.searchTopic = .title
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateContentForResult()
    }

    func updateContentForResult() {
        if viewModel.currentImages.isEmpty {

            searchHeader?.searchField.becomeFirstResponder()

            if noResultsView == nil {
                let noResultsView = NoResultsMessageView()
                self.noResultsView = noResultsView

                view.addSubview(noResultsView)
                noResultsView.translatesAutoresizingMaskIntoConstraints = false
                let constraints = [
                    noResultsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                    noResultsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                    noResultsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ]
                NSLayoutConstraint.activate(constraints)
            }
            guard let noResultsView else {
                return
            }

            if viewModel.searchInProgress {
                noResultsView.setMessage(.inProgress)
            } else if viewModel.searchQuery.isEmpty {
                noResultsView.setMessage(.newSearch)
            } else {
                noResultsView.setMessage(.noResultsFound)
            }
        } else {

            searchHeader?.searchField.resignFirstResponder()
            noResultsView?.removeFromSuperview()
            noResultsView = nil
        }
    }

    private func showSearchError(_ error: Error) {

        let alert = UIAlertController(
            title: "SearchErrorAlert.Title".localized,
            message: "SearchErrorAlert.Message".localized(error.localizedDescription),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "SearchErrorAlert.Button".localized, style: .cancel, handler: nil))
        Task { @MainActor in
            present(alert, animated: true)
        }
    }
}

// MARK: - Collection View Delegate

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
