//
//  CGPoint.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 25/11/20.
//

import Foundation
import UIKit
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }

    func isPointValid (array: [CGPoint]) -> Bool {
        var isValidPoint = true
        array.forEach { (localPoint) in
            if localPoint.distance(to: self) < 300 {
                isValidPoint = false
            }
        }
        return isValidPoint
    }

    static func generateRandomPoint() -> CGPoint {
        return CGPoint(x: CGFloat.random(in: -1000...1000), y: CGFloat.random(in: -1000...1000))
    }

}
