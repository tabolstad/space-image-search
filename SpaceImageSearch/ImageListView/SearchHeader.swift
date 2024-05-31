//
//  SearchHeader.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/31/24.
//

import UIKit

final class SearchHeader: UICollectionReusableView {

    let searchField = UISearchTextField()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViewLayout()
        searchField.backgroundColor = UIColor.lightGray
    }

    private func setupViewLayout() {

        searchField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchField)

        let constraints = [
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
