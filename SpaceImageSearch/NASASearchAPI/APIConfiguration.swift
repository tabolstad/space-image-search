//
//  APIConfiguration.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

struct APIConfiguration {
    let baseURL: String

    static let nasa = APIConfiguration(baseURL: "https://images-api.nasa.gov")
}
