//
//  TestData.swift
//  SpaceImageSearchTests
//
//  Created by Timothy Bolstad on 5/30/24.
//

import Foundation

final class TestData {
    static func json<T: Decodable>(_ fileName: String) throws -> T {

        let testBundle = Bundle(for: TestData.self)
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("Failed to locate json file in test bundle: \(fileName)")
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(T.self, from: data)
        return response
    }
}
