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

    private let reuseIdentifier = "ImageCollectionCell"
    private let viewModel: ImageSearchViewModel
    private lazy var dataSource: ImageCollectionDataSource = buildDataSource()

    private static var columns: Int = 3
    private static var itemHeight: CGFloat = 140
    private static var itemInset: CGFloat = 4
    private static var itemSpacing: CGFloat = 4
    private static var lineSpacing: CGFloat = 4
    private static var contentInset: CGFloat = 16

    init(service: ImageService) {
        
        let viewModel = ImageSearchViewModel(service: service)
        self.viewModel = viewModel
        let layout = Self.makeLayout()
        super.init(collectionViewLayout: layout)
        viewModel.dataSource = dataSource
        
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func makeLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemLayoutSize = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0 / CGFloat(columns)),
                heightDimension: NSCollectionLayoutDimension.absolute(itemHeight)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset
            )
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .uniformAcrossSiblings(estimate: itemHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: columns)
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(itemSpacing)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = lineSpacing
            section.contentInsets = NSDirectionalEdgeInsets(top: contentInset,
                                                            leading: contentInset,
                                                            bottom: contentInset,
                                                            trailing: contentInset)
            return section
        }
        return layout
    }

    private func buildDataSource() -> ImageCollectionDataSource {

        let dataSource = ImageCollectionDataSource(collectionView: self.collectionView) { (collectionView, indexPath, spaceImage) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
            cell.title.text = "\(spaceImage.title)"
            cell.preview.image = UIImage(systemName: "person")
            cell.previewUrl = spaceImage.thumbnail
            return cell
        }
        return dataSource
    }
}
