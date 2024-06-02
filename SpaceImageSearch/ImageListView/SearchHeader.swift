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

    var searchPlaceholder: String = "" {
        didSet {
            searchField.placeholder = searchPlaceholder
        }
    }

    var searchString: String = "" {
        didSet {
            searchField.text = searchString
        }
    }

    private let searchFieldHeight: CGFloat = 44.0
    private let stackSpacing: CGFloat = 8.0

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        searchField.backgroundColor = UIColor.searchBarBackground
        searchField.autocorrectionType = .no
        searchField.autocapitalizationType = .none
        searchField.spellCheckingType = .no

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
        stackView.spacing = stackSpacing
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

            searchField.heightAnchor.constraint(equalToConstant: searchFieldHeight),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor),

            categoryPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryPicker.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
