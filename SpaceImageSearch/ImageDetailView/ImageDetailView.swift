//
//  ImageDetailView.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/31/24.
//

import UIKit

final class ImageDetailView: UIView {

    let viewModel: ImageDetailViewModel
    
    let title = UILabel()

    let padding: CGFloat = 10.0

    init(viewModel: ImageDetailViewModel) {

        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = UIColor.orange
        refreshData()
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func refreshData() {

        let spaceImage = viewModel.spaceImage

        title.text = spaceImage.title
    }

    private func setupViewLayout() {

        addSubview(title)

        title.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            title.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            title.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -padding),
            title.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
