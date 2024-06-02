//
//  ImageDetailViewController.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/31/24.
//

import UIKit

final class ImageDetailViewController: UIViewController {

    let viewModel: ImageDetailViewModel

    init(spaceImage: SpaceImage, imageService: ImageService, thumbnail: UIImage?) {
        let viewModel = ImageDetailViewModel(
            spaceImage: spaceImage,
            imageService: imageService,
            thumbnail: thumbnail
        )
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.showZoomView = { [weak self] in
            self?.showZoomView()
        }
        viewModel.closeZoomView = { [weak self] in
            self?.closeZoomView()
        }
    }

    override func loadView() {
        super.view = ImageDetailView(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showZoomView() {
        let zoomViewController = ImageZoomViewController(viewModel: viewModel)
        zoomViewController.modalPresentationStyle = .fullScreen
        present(zoomViewController, animated: true)
    }

    func closeZoomView() {
        presentedViewController?.dismiss(animated: true)
    }
}
