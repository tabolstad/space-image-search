//
//  UIButton+ImageButton.swift
//  SpaceImageSearch
//
//  Created by Timothy Bolstad on 6/2/24.
//

import UIKit

extension UIButton.Configuration {
    public static func imageButton(_ icon: String) -> UIButton.Configuration {
        var style = UIButton.Configuration.plain()
        var background = UIButton.Configuration.filled().background
        background.cornerRadius = 20
        style.background = background
        style.image = UIImage(systemName: icon)
        return style
    }
}
