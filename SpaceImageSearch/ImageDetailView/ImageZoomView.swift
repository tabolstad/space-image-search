//
//  ImagePanView.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 6/2/24.
//

import UIKit

final class ImageZoomViewController: UIViewController, UIScrollViewDelegate {

    let viewModel: ImageDetailViewModel
    let zoomView: ImageZoomView

    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        let zoomView = ImageZoomView(viewModel: viewModel)
        self.zoomView = zoomView

        super.init(nibName: nil, bundle: nil)
        self.view = zoomView
        zoomView.scrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView.imageView
    }
}

final class ImageZoomView: UIView {

    let viewModel: ImageDetailViewModel
    let scrollView = UIScrollView()
    let closeButton = UIButton()
    let imageView = UIImageView()

    let closeButtonSize: CGFloat = 44.0

    init(viewModel: ImageDetailViewModel) {

        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViewLayout()

        backgroundColor = UIColor.viewBackground
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 2.0
        let closeButtonConfig = UIButton.Configuration.imageButton("x.circle.fill")
        let closeAction = UIAction { [weak self] _ in
            self?.viewModel.closeZoomView?()
        }
        closeButton.configuration = closeButtonConfig
        closeButton.addAction(closeAction, for: .touchUpInside)
        imageView.image = viewModel.thumbnail
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewLayout() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        addSubview(closeButton)
        scrollView.addSubview(imageView)

        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            closeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: closeButtonSize),
            closeButton.widthAnchor.constraint(equalToConstant: closeButtonSize)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
