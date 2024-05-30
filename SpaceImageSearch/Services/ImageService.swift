//
//  ImageService.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

protocol ImageService {
    func search(query: String) async throws -> APISearchResponse
}

class NASAImageService: ImageService {

    let api = NASALibraryAPI(config: .nasa)

    func search(query: String) async throws -> APISearchResponse {
        let query = URLQueryItem(name: "q", value: "Rover")
        let response: APISearchResponse = try await api.request(.search([query]))
        return response
    }
}
