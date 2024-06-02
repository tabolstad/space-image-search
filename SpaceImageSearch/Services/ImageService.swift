//
//  ImageService.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import UIKit

enum ImageServiceError: Error {
    case imageFetchingError
    case imageDataDecodingError
}

protocol ImageService {
    func search(query: String, searchTopic: SearchTopic?) async throws -> ImageBatch
    func fetchNextPage(url: URL) async throws -> ImageBatch
    func fetchImage(url: URL) async throws -> UIImage
}

final class NASAImageService: ImageService {

    let api = NASALibraryAPI(config: .nasa)
    var nextPages = Set<URL>()

    func search(query: String, searchTopic: SearchTopic?) async throws -> ImageBatch {
        nextPages = []
        let searchTopic = searchTopic?.parameter ?? SearchTopic.freeTextSearch
        let query = URLQueryItem(name: searchTopic, value: query)
        do {
            let response: APISearchResponse = try await api.request(.search([query]))
            let batch = packageImageBatch(response: response)
            return batch
        } catch {
            if let urlError = error as? URLError,
               urlError.code == URLError.Code.cancelled {
                return ImageBatch(images: [],
                                  totalCount: 0,
                                  next: nil)
            } else {
                throw error
            }
        }
    }

    func fetchNextPage(url: URL) async throws -> ImageBatch {
        guard !nextPages.contains(url) else {
            return ImageBatch(images: [], totalCount: 0, next: nil)
        }
        nextPages.insert(url)
        do {
            let nextResponse: APISearchResponse = try await api.requestUrl(url)
            let batch = packageImageBatch(response: nextResponse)
            return batch
        } catch {
            return ImageBatch(images: [], totalCount: 0, next: nil)
        }
    }

    private func packageImageBatch(response: APISearchResponse) -> ImageBatch {
        let images = response.collection.items.compactMap {
            SpaceImage(apiItem: $0)
        }
        let totalCount = response.collection.metadata?.total_hits ?? 0
        let nextPage = response.collection.links?
            .first(where: { $0.rel == "next" })
            .flatMap { URL(string: $0.href.replacingOccurrences(of: "http", with: "https")) }
        let batch = ImageBatch(images: images,
                               totalCount: totalCount,
                               next: nextPage)
        return batch
    }

    func fetchImage(url: URL) async throws -> UIImage {

        let imageData = try await api.fetchImageData(url: url)
        guard let image = UIImage(data: imageData) else {
            throw ImageServiceError.imageDataDecodingError
        }
        return image
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

    func fetchNextPage(url: URL) async throws -> ImageBatch {
        return ImageBatch(images: [], totalCount: 0, next: nil)
    }

    func search(query: String, searchTopic: SearchTopic?) async throws -> ImageBatch {
        return ImageBatch(images: [], totalCount: 0, next: nil)
    }

    func fetchImage(url: URL) async throws -> UIImage {
        return UIImage(systemName: "person")!
    }
}
#endif
