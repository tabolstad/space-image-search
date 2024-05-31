//
//  SpaceImageTests.swift
//  SpaceImageSearchTests
//
//  Created by Timothy Bolstad on 5/31/24.
//

import XCTest
@testable import SpaceImageSearch

final class SpaceImageTests: XCTestCase {

    func testSpaceImageCreation() throws {

        let response: APISearchResponse = try TestData.json("nasa_search_response")
        let collection = response.collection

        let optionalImage = collection.items.first.flatMap { SpaceImage(apiItem: $0) }
        let image = try XCTUnwrap(optionalImage)
        XCTAssertEqual(image.photographer, "NASA/JPL / Some Guy")
    }
}
