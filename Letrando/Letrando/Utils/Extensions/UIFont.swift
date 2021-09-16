//
//  UIFont.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import UIKit

extension UIFont {
    static func set(size: CGFloat, weight: UIFont.Weight, textStyle: UIFont.TextStyle) -> UIFont {
        var roundedFont: UIFont?
        let systemFont = systemFont(ofSize: size, weight: weight)
        
        if let fontDescriptor = systemFont.fontDescriptor.withDesign(.rounded) {
           roundedFont = UIFont(descriptor: fontDescriptor, size: size)
        }
        guard let roundedFont = roundedFont else {
            return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: systemFont)
        }
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: roundedFont)
    }
}
