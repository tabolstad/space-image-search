//
//  ImageSearchViewModel.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

final class ImageSearchViewModel {
    var service: ImageService

    init(service: ImageService) {
        self.service = service
    }
}
