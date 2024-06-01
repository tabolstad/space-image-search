//
//  SearchTopic.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 6/1/24.
//

import Foundation

enum SearchTopic: Int {
    case title
    case photographer
    case location

    var parameter: String {
        switch self {
        case .title:
            "title"
        case .photographer:
            "photographer"
        case .location:
            "location"
        }
    }

    static var freeTextSearch: String {
        return "q"
    }
}
