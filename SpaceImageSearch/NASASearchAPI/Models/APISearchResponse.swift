//
//  SearchResponse.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

struct APISearchResponse: Decodable {
    let collection: APICollection
}

struct APICollection: Decodable {
    let version: String
    let href: String
    let items: [APIItem]
    let metadata: APIMetadata?
    let links: [APILink]?
}

struct APIItem: Decodable {
    let href: String
    let data: [APIDataItem]
    let links: [APILink]?
}

struct APIDataItem: Decodable {
    let nasa_id: String

    let center: String
    let date_created: String
    let description: String?
    let keywords: [String]?
    let media_type: String?
    let title: String

    let location: String?
    let photographer: String?
    let secondary_creator: String?
}

struct APILink: Decodable {
    let href: String
    let rel: String
    let render: String?
    let prompt: String?
}

struct APIMetadata: Decodable {
    let total_hits: Int
}
