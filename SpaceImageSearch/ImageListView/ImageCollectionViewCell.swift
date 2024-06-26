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
    
    let padding: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    let cellCornerRadius: CGFloat = 10.0
    let imageCornerRadius: CGFloat = 8.0

    static let placeholder = UIImage(systemName: "moon.stars")!
    static let errorPlaceholder = UIImage(systemName: "moon.stars.fill")!

    var previewUrl: URL? {
        didSet {
            updateImage()
        }
    }
    var fetchImage: ((URL) async throws -> UIImage)?
    private var imageFetchTask: Task<Void, Error>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = UIColor.darkGray
        layer.cornerRadius = cellCornerRadius
        
        preview.backgroundColor = UIColor.gray
        preview.layer.cornerRadius = imageCornerRadius
        preview.contentMode = .scaleAspectFill
        preview.image = Self.placeholder
        preview.clipsToBounds = true

        title.textColor = UIColor.darkGray
        title.font = UIFont.preferredFont(forTextStyle: .caption2)
        title.textAlignment = .center

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
            preview.leadingAnchor.constraint(equalTo: leadingAnchor),
            preview.trailingAnchor.constraint(equalTo: trailingAnchor),
            preview.topAnchor.constraint(equalTo: topAnchor),
            preview.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -spacing),
            preview.heightAnchor.constraint(equalTo: preview.widthAnchor),

            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageFetchTask?.cancel()
    }

    private func updateImage() {

        guard let previewUrl else {
            applyImage(Self.errorPlaceholder)
            return
        }
        let task = Task { [weak self] in
            guard let self else {
                return
            }
            do {
                guard let image = try await self.fetchImage?(previewUrl) else {
                    return
                }
                applyImage(image)
            } catch {
                applyImage(Self.errorPlaceholder)
                throw error
            }
        }
        imageFetchTask = task
    }

    @MainActor
    private func applyImage(_ image: UIImage) {
        preview.image = image
    }
}
