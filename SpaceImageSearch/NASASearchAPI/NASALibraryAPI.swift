//
//  NASASearchAPI.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

enum APIError: Error {
    case unexpectedResponse
    case httpResponseError(Int)
}

final class NASALibraryAPI {

    let apiConfiguration: APIConfiguration
    let urlSession: URLSession

    init(config: APIConfiguration,
         urlSession: URLSession = URLSession(configuration: .default)) {
        self.apiConfiguration = config
        self.urlSession = urlSession
    }

    func request<T: Decodable>(_ endpoint: NASAEndpoint) async throws -> T {
        // Build Request
        let request = buildRequest(endpoint: endpoint)

        // Send Request
        let (data, urlResponse) = try await urlSession.data(for: request)

        // Handle Response
        guard let response = urlResponse as? HTTPURLResponse else {
            throw APIError.unexpectedResponse
        }
        guard response.statusCode == 200 else {
            throw APIError.httpResponseError(response.statusCode)
        }
        // Decode Data
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }

    private func buildRequest(endpoint: NASAEndpoint) -> URLRequest {
        
        guard let baseURL = URL(string: apiConfiguration.baseURL) else {
            fatalError("API base URL is misconfigured.")
        }
        let endpoint = endpoint.info
        var url = baseURL.appendingPathComponent(endpoint.path)
        if let query = endpoint.query {
            url.append(queryItems: query)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        return request
    }
}
