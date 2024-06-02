//
//  Image.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

struct SpaceImage: Hashable {
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
              let link = apiItem.links?.first,
              let thumbnail = URL(string: link.href) else {
            return nil
        }

        self.id = data.nasa_id
        self.description = data.description ?? ""
        self.location = data.location ?? data.center ?? ""
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

extension SpaceImage {
    static var mockLongStrings: SpaceImage {
        let description = "Rover team members with the Mars Exploration Rover. Rover team members with the Mars Exploration Rover. Rover team members with the Mars Exploration Rover. Rover team members with the Mars Exploration Rover. Rover team members with the Mars Exploration Rover. Rover team members with the Mars Exploration Rover."

        let location = "Jet Propulsion Laboratory, Jet Propulsion Laboratory, Jet Propulsion Laboratory"
        let photographer = "Bob The Photographer Bob The Photographer Bob The Photographer"
        let title = "Rover Team Rover Team Rover Team Rover Team"

        let spaceImage = SpaceImage(id: "A",
                                    description: description,
                                    location: location,
                                    photographer: photographer,
                                    thumbnail: URL(safe: "https://images-assets.nasa.gov/image/PIA04826/PIA04826~thumb.jpg"),
                                    title: title)
        return spaceImage
    }
}
