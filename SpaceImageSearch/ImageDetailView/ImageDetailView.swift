//
//  ImageDetailView.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/31/24.
//

import UIKit

final class ImageDetailView: UIView {

    let viewModel: ImageDetailViewModel

    let scrollView = UIScrollView()

    let stackView = UIStackView()
    let image = UIImageView()
    let title = UILabel()
    let location = UILabel()
    let photographer = UILabel()
    let imageDescription = UILabel()

    let lineSpacing: CGFloat = 10.0
    let imageCorner: CGFloat = 10.0
    let scrollContentMargin: CGFloat = 16.0

    static let placeholder = UIImage(systemName: "moon.stars")!

    init(viewModel: ImageDetailViewModel) {

        self.viewModel = viewModel
        
        super.init(frame: .zero)

        self.backgroundColor = UIColor.viewBackground

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
        location.numberOfLines = -1
        photographer.numberOfLines = -1

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

    private func setupViewLayout() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(stackView)

        let viewsInStack = [
            title,
            image,
            location,
            photographer,
            imageDescription
        ]
        viewsInStack.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(view)
        }

        title.setContentHuggingPriority(.defaultLow, for: .horizontal)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: scrollContentMargin),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -scrollContentMargin),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: (-2.0 * scrollContentMargin)),

            title.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            image.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            image.heightAnchor.constraint(equalTo: stackView.widthAnchor),
            location.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            location.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            photographer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            photographer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            imageDescription.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            imageDescription.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
