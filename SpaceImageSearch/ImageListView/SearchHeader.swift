//
//  SearchHeader.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/31/24.
//

import UIKit

final class SearchHeader: UICollectionReusableView {

    let stackView = UIStackView()
    let searchField = UISearchTextField()
    let categoryPicker = UISegmentedControl()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        searchField.backgroundColor = UIColor.searchBarBackground

        categoryPicker.isMomentary = false
        categoryPicker.insertSegment(with: UIImage(systemName: "doc.text.magnifyingglass"),
                                     at: SearchTopic.title.rawValue,
                                     animated: false)
        categoryPicker.insertSegment(with: UIImage(systemName: "person.crop.square.badge.camera"),
                                     at: SearchTopic.photographer.rawValue,
                                     animated: false)
        categoryPicker.insertSegment(with: UIImage(systemName: "location.magnifyingglass"),
                                     at: SearchTopic.location.rawValue,
                                     animated: false)

        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        stackView.alignment = .center

        setupViewLayout()
    }

    private func setupViewLayout() {

        stackView.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.addArrangedSubview(searchField)
        stackView.addArrangedSubview(categoryPicker)

        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            searchField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            categoryPicker.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
