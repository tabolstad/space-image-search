//
//  String+Localized.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 6/2/24.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localized(_ value: String) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String.localizedStringWithFormat(format, value)
    }
}
