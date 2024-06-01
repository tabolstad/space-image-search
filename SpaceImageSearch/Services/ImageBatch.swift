//
//  ImageBatch.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 6/1/24.
//

import Foundation

struct ImageBatch {
    let images: [SpaceImage]
    let totalCount: Int
    let next: URL?
}
