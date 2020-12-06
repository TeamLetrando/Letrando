//
//  String.swift
//  SwiftCharts
//
//  Created by ischuetz on 13/08/16.
//  Copyright © 2016 ivanschuetz. All rights reserved.
//
// swiftlint:disable all
import UIKit

extension String {
    
    subscript (i: Int) -> Character { // swiftlint:disable:this identifier_name
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String { // swiftlint:disable:this identifier_name
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String { // swiftlint:disable:this identifier_name
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[start..<end])
    }

    func size(_ font: UIFont) -> CGSize {
        #if swift(>=4)
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font]).size()
        #else
        return NSAttributedString(string: self, attributes: [NSFontAttributeName: font]).size()
        #endif
    }
    
    func width(_ font: UIFont) -> CGFloat {
        return size(font).width
    }

    func height(_ font: UIFont) -> CGFloat {
        return size(font).height
    }
    
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }

    func fittingSubstring(_ width: CGFloat, font: UIFont) -> String {
        for i in stride(from: count, to: 0, by: -1) { // swiftlint:disable:this identifier_name
            let substr = self[0..<i]
            if substr.width(font) <= width {
                return substr
            }
        }
        return ""
    }

    func truncate(_ width: CGFloat, font: UIFont) -> String {
        let ellipsis = "..."
        let substr = fittingSubstring(width - ellipsis.width(font), font: font)
        if substr.count != count {
            return "\(substr.trim())\(ellipsis)"
        } else {
            return self
        }
    }
}
