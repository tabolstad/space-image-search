//
//  SpaceImageCollectionViewCell.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/31/24.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    let preview = UIImageView()
    let title = UILabel()
    
    let padding: CGFloat = 10.0
    let spacing: CGFloat = 10.0
    let cellCornerRadius: CGFloat = 10.0
    let imageCornerRadius: CGFloat = 8.0

    var previewUrl: URL? {
        didSet {
            fetchImage()
        }
    }
    var imageFetchTask: Task<Void, Error>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        title.textColor = UIColor.darkGray
        preview.backgroundColor = UIColor.gray
        layer.cornerRadius = cellCornerRadius
        preview.layer.cornerRadius = imageCornerRadius
        preview.contentMode = .scaleAspectFit
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewLayout() {

        addSubview(title)
        addSubview(preview)

        title.translatesAutoresizingMaskIntoConstraints = false
        preview.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            preview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            preview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            preview.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            preview.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -spacing),

            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            title.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageFetchTask?.cancel()
    }

    private func fetchImage() {
        let task = Task {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            applyImage(UIImage(systemName: "clock")!)
        }
        imageFetchTask = task
    }

    @MainActor
    private func applyImage(_ image: UIImage) {
        preview.image = image
    }
}
