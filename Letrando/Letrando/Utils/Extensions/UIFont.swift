//
//  UIFont.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import UIKit

extension UIFont {
    static func set(size: CGFloat, weight: UIFont.Weight, textStyle: UIFont.TextStyle) -> UIFont {

        let customFont = systemFont(ofSize: size, weight: weight)
        
        if let fontDescriptor = customFont.fontDescriptor.withDesign(.rounded) {
            let roundedFont = UIFont(descriptor: fontDescriptor, size: size)
            return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: roundedFont)
        }
     
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: customFont)
    }
}
