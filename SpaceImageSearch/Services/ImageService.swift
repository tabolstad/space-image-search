//
//  ImageService.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import UIKit

protocol ImageService {
    func search(query: String, searchTopic: SearchTopic?) async throws -> [SpaceImage]
    func fetchImage(url: URL) async throws -> UIImage
}

extension ImageService {
    func fetchImage(url: URL) async throws -> UIImage {
        let session = URLSession(configuration: .default)
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ImageServiceError.imageFetchingError
        }
        guard let image = UIImage(data: data) else {
            throw ImageServiceError.imageDataDecodingError
        }
        return image
    }
}

enum ImageServiceError: Error {
    case imageFetchingError
    case imageDataDecodingError
}

enum SearchTopic: Int {
    case title
    case photographer
    case location

    var parameter: String {
        switch self {
        case .title:
            "title"
        case .photographer:
            "photographer"
        case .location:
            "location"
        }
    }

    static var freeTextSearch: String {
        return "q"
    }
}

final class NASAImageService: ImageService {

    let api = NASALibraryAPI(config: .nasa)

    func search(query: String, searchTopic: SearchTopic?) async throws -> [SpaceImage] {
        let searchTopic = searchTopic?.parameter ?? SearchTopic.freeTextSearch
        let query = URLQueryItem(name: searchTopic, value: query)
        let response: APISearchResponse = try await api.request(.search([query]))
        let images = response.collection.items.compactMap {
            SpaceImage(apiItem: $0)
        }
        return images
    }
}

#if DEBUG
final class MockImageService: ImageService {
    func search(query: String, searchTopic: SearchTopic?) async throws -> [SpaceImage] {
        let images = [
            SpaceImage(id: "A",
                       description: "Image A is a space image.",
                       location: "JPL",
                       photographer: "Jane Doe",
                       thumbnail: URL(safe: "https://images-assets.nasa.gov/image/PIA04826/PIA04826~thumb.jpg"),
                       title: "Image A"),
            SpaceImage(id: "B",
                       description: "Image B is another space image.",
                       location: "JPL",
                       photographer: "John Doe",
                       thumbnail: URL(safe: "https://images-assets.nasa.gov/image/PIA05151/PIA05151~thumb.jpg"),
                       title: "Image B"),
            SpaceImage(id: "C",
                       description: "Image C is another space image.",
                       location: "JPL",
                       photographer: "John Doe",
                       thumbnail: URL(safe: "https://images-assets.nasa.gov/image/PIA05151/PIA05151~thumb.jpg"),
                       title: "Image C"),
            SpaceImage(id: "D",
                       description: "Image D is another space image.",
                       location: "JPL",
                       photographer: "John Doe",
                       thumbnail: URL(safe: "https://images-assets.nasa.gov/image/PIA05151/PIA05151~thumb.jpg"),
                       title: "Image D")
        ]
        return images
    }
}

extension URL {
    init(safe: String) {
        guard let url = URL(string: safe) else {
            fatalError("Safe URL is misconfigured: \(safe)")
        }
        self = url
    }
}
#endif
