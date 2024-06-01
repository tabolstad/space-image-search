//
//  NASASearchAPI.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

enum APIError: Error {
    case unexpectedResponse
    case badRequest
    case notFound
    case serverError
    case urlFetchingError
    case imageFetchingError
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
        try handleResponse(urlResponse)
        // Decode Data
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }

    func requestUrl<T: Decodable>(_ url: URL) async throws -> T {

        let (data, response) = try await urlSession.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.urlFetchingError
        }
        let decoder = JSONDecoder()
        let nextResponse = try decoder.decode(T.self, from: data)
        return nextResponse
    }

    func fetchImageData(url: URL) async throws -> Data {

        let (data, response) = try await urlSession.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.imageFetchingError
        }

        return data
    }

    private func handleResponse(_ urlResponse: URLResponse) throws {
        guard let response = urlResponse as? HTTPURLResponse else {
            throw APIError.unexpectedResponse
        }
        switch response.statusCode {
        case 200:
            break
        case 400:
            throw APIError.badRequest
        case 404:
            throw APIError.notFound
        case 500, 502, 503, 504:
            throw APIError.serverError
        default:
            throw APIError.unexpectedResponse
        }
    }

    private func buildRequest(endpoint: NASAEndpoint) -> URLRequest {

        let baseURL = apiConfiguration.baseURL
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
