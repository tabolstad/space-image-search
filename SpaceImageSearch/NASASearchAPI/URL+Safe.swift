//
//  URL+Safe.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 6/1/24.
//

import Foundation

extension URL {
    init(safe: String) {
        guard let url = URL(string: safe) else {
            fatalError("Safe URL is misconfigured: \(safe)")
        }
        self = url
    }
}
