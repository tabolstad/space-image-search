//
//  ImageSearchView.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import UIKit

final class ImageSearchView: UIView {

    var viewModel: ImageSearchViewModel

    internal init(viewModel: ImageSearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = UIColor.green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
