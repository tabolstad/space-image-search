//
//  SpaceImageSearchTests.swift
//  SpaceImageSearchTests
//
//  Created by Timothy Bolstad on 5/30/24.
//

import XCTest
@testable import SpaceImageSearch

final class SpaceImageSearchResponseTests: XCTestCase {

    func testSearchResponseDecoding() throws {

        let response: APISearchResponse = try TestData.json("nasa_search_response")
        let collection = response.collection
        XCTAssertEqual(collection.version, "1.0")
        XCTAssertEqual(collection.metadata.total_hits, 7522)
        XCTAssertEqual(collection.links.first?.rel, "next")

        let items = collection.items
        let item = items[0]
        XCTAssertEqual(items.count, 8)
        XCTAssertEqual(item.href, "https://images-assets.nasa.gov/image/PIA04826/collection.json")
        let data = item.data.first!
        XCTAssertEqual(data.title, "Rover Team")
        XCTAssertEqual(data.description, "Rover team members with the Mars Exploration Rover.")
        XCTAssertEqual(data.photographer, "Some Guy")
        XCTAssertEqual(data.secondary_creator, "NASA/JPL")
        XCTAssertEqual(data.location, "Jet Propulsion Laboratory")
    }

    func testSearchResponseDecodingNilProperties() throws {

        let response: APISearchResponse = try TestData.json("nasa_search_response")
        let collection = response.collection
        let item = collection.items[1]
        let data = item.data.first!
        XCTAssertNil(data.location)
        XCTAssertNil(data.photographer)
        XCTAssertNil(data.secondary_creator)
    }
}
