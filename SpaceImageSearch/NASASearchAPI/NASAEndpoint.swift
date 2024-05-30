//
//  NASAEndpoint.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

enum NASAEndpoint {
    struct EndpointInfo {
        var method: HTTPMethod
        var path: String
        var query: [URLQueryItem]?
    }

    case search([URLQueryItem])

    var info: EndpointInfo {
        switch self {
        case .search(let query):
            return EndpointInfo(method: .get, path: "search", query: query)
        }
    }
}
