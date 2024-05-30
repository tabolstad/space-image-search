//
//  ImageSearchViewController.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import UIKit

final class ImageSearchViewController: UIViewController {

    var viewModel: ImageSearchViewModel

    init(service: ImageService) {
        let viewModel = ImageSearchViewModel(service: service)
        let listView = ImageSearchView(viewModel: viewModel)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view = listView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
