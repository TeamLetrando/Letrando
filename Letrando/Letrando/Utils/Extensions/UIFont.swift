//
//  UIFont.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import UIKit

extension UIFont {
    static func set(size: CGFloat, weight: Weight) -> UIFont {
        let systemFont = systemFont(ofSize: size, weight: weight)
        if let fontDescriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: fontDescriptor, size: size)
        }
        return systemFont
    }
}
