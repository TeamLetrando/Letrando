//
//  CGPoint.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 25/11/20.
//

import Foundation
import ARKit

extension CGPoint {
    
    /// Extracts the screen space point from a vector returned by SCNView.projectPoint(_:).
    init(_ vector: SCNVector3) {
        self.init(x: CGFloat(vector.x), y: CGFloat(vector.y))
    }

    /// Returns the length of a point when considered as a vector. (Used with gesture recognizers.)
    var length: CGFloat {
        return sqrt(x * x + y * y)
    }
    
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
