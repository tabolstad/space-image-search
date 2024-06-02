//
//  NoResultsMessageView.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 6/2/24.

import UIKit

enum NoResultsMessage: String {
    case inProgress
    case noResultsFound
    case newSearch

    var display: String {
        switch self {
        case .noResultsFound:
            "SearchScreen.NoResultsFoundMessage".localized
        case .newSearch:
            "SearchScreen.NewSearchMessage".localized
        case .inProgress:
            ""
        }
    }
}

final class NoResultsMessageView: UIView {

    let message = UILabel()
    let progress = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor.viewBackground
        message.numberOfLines = -1
        message.textAlignment = .center
        message.font = UIFont.preferredFont(forTextStyle: .title2)
        message.textColor = UIColor.lightGray
        progress.isHidden = true
        message.isHidden = true

        isUserInteractionEnabled = false
        setupViewLayout()
    }

    private func setupViewLayout() {

        message.translatesAutoresizingMaskIntoConstraints = false
        progress.translatesAutoresizingMaskIntoConstraints = false
        addSubview(message)
        addSubview(progress)

        let constraints = [
            message.leadingAnchor.constraint(equalTo: leadingAnchor),
            message.trailingAnchor.constraint(equalTo: trailingAnchor),
            message.topAnchor.constraint(equalTo: topAnchor),
            message.bottomAnchor.constraint(equalTo: bottomAnchor),

            progress.centerXAnchor.constraint(equalTo: centerXAnchor),
            progress.centerYAnchor.constraint(equalTo: centerYAnchor),
            progress.widthAnchor.constraint(equalToConstant: 100),
            progress.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setMessage(_ messageType: NoResultsMessage) {
        switch messageType {
        case .inProgress:
            progress.isHidden = false
            message.isHidden = true
            progress.startAnimating()
        case .noResultsFound, .newSearch:
            progress.isHidden = true
            message.isHidden = false
            message.text = messageType.display
        }
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
