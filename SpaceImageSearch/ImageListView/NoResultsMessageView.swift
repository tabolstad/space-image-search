//
//  NoResultsMessageView.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 6/2/24.

import UIKit

enum NoResultsMessage: String {
    case noResultsFound
    case newSearch

    var display: String {
        switch self {
        case .noResultsFound:
            "SearchScreen.NoResultsFoundMessage".localized
        case .newSearch:
            "SearchScreen.NewSearchMessage".localized
        }
    }
}

final class NoResultsMessageView: UIView {

    let message = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor.viewBackground
        message.numberOfLines = -1
        message.textAlignment = .center
        message.font = UIFont.preferredFont(forTextStyle: .title2)
        message.textColor = UIColor.lightGray
        isUserInteractionEnabled = false
        setupViewLayout()
    }

    private func setupViewLayout() {

        message.translatesAutoresizingMaskIntoConstraints = false
        addSubview(message)

        let constraints = [
            message.leadingAnchor.constraint(equalTo: leadingAnchor),
            message.trailingAnchor.constraint(equalTo: trailingAnchor),
            message.topAnchor.constraint(equalTo: topAnchor),
            message.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setMessage(_ message: NoResultsMessage) {
        self.message.text = message.display
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.layer.opacity = 0.0
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        UIView.animate(withDuration: 2.0) {
            self.layer.opacity = 1.0
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
