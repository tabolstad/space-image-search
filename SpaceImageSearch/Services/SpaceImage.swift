//
//  Image.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

struct SpaceImage {
    let id: String
    let description: String
    let location: String
    let photographer: String
    let thumbnail: URL
    let title: String
}

extension SpaceImage {
    init?(apiItem: APIItem) {

        guard let data = apiItem.data.first,
              let link = apiItem.links.first,
              let thumbnail = URL(string: link.rel) else {
            return nil
        }

        self.id = data.nasa_id
        self.description = data.description
        self.location = data.location ?? data.center
        self.thumbnail = thumbnail
        self.title = data.title

        if let photographer = data.photographer,
           let secondary = data.secondary_creator {
            self.photographer = "\(secondary) / \(photographer)"
        } else if let photographer = data.photographer {
            self.photographer = photographer
        } else if let secondary = data.secondary_creator {
            self.photographer = secondary
        } else {
            self.photographer = ""
        }
    }
}
