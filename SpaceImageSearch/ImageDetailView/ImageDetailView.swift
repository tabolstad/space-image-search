//
//  ImageDetailView.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/31/24.
//

import UIKit

final class ImageDetailView: UIView {

    let viewModel: ImageDetailViewModel

    let stackView = UIStackView()
    let image = UIImageView()
    let title = UILabel()
    let location = UILabel()
    let photographer = UILabel()
    let imageDescription = UILabel()
    let spacer = UIView()

    let padding: CGFloat = 20.0
    let lineSpacing: CGFloat = 10.0
    let imageCorner: CGFloat = 10.0

    static let placeholder = UIImage(systemName: "moon.stars")!

    init(viewModel: ImageDetailViewModel) {

        self.viewModel = viewModel
        super.init(frame: .zero)
        self.tintColor = UIColor.darkGray
        self.backgroundColor = UIColor.white

        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = lineSpacing

        image.contentMode = .scaleAspectFill
        image.image = Self.placeholder
        image.layer.cornerRadius = imageCorner
        image.backgroundColor = UIColor.lightGray
        image.clipsToBounds = true

        title.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        location.font = UIFont.preferredFont(forTextStyle: .title1)
        photographer.font = UIFont.preferredFont(forTextStyle: .body)
        photographer.textColor = UIColor.gray
        imageDescription.font = UIFont.preferredFont(forTextStyle: .body)

        title.numberOfLines = -1
        imageDescription.numberOfLines = -1

        spacer.isAccessibilityElement = false

        refreshData()
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func refreshData() {
        title.text = viewModel.title
        location.text = viewModel.location
        photographer.text = viewModel.photographer
        imageDescription.text = viewModel.imageDescription
        image.image = viewModel.thumbnail ?? Self.placeholder
    }

    @MainActor
    private func applyImage(_ image: UIImage) {
        self.image.image = image
    }

    private func setupViewLayout() {

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let views = [
            title,
            image,
            location,
            photographer,
            imageDescription,
            spacer
        ]
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(view)
        }

        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),

            image.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            title.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            location.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            photographer.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            imageDescription.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),            
            image.heightAnchor.constraint(equalTo: image.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
