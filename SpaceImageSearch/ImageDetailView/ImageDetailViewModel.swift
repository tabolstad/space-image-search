//
//  ImageDetailViewModel.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/31/24.
//

import UIKit

final class ImageDetailViewModel {
    
    let spaceImage: SpaceImage
    let imageService: ImageService
    let thumbnail: UIImage?

    internal init(spaceImage: SpaceImage, imageService: ImageService, thumbnail: UIImage?) {
        self.spaceImage = spaceImage
        self.imageService = imageService
        self.thumbnail = thumbnail
    }

    var title: String {
        return spaceImage.title
    }

    var location: String {
        return spaceImage.location
    }

    var photographer: String {
        return spaceImage.photographer
    }

    var imageDescription: String {
        return spaceImage.description
    }

    func fetchImage() async throws -> UIImage {
        let url = spaceImage.thumbnail
        return try await imageService.fetchImage(url: url)
    }
}
