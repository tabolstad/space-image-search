//
//  ImageDetailViewController.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/31/24.
//

import UIKit

final class ImageDetailViewController: UIViewController {

    let viewModel: ImageDetailViewModel

    init(spaceImage: SpaceImage) {
        let viewModel = ImageDetailViewModel(spaceImage: spaceImage)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.view = ImageDetailView(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
