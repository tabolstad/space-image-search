//
//  APIConfiguration.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

struct APIConfiguration {
    let baseURL: URL

    static let nasa = APIConfiguration(baseURL: URL(safe: "https://images-api.nasa.gov"))
}
