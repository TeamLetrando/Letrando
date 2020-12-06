//
//  CGPoint.swift
//  SwiftCharts
//
//  Created by ischuetz on 30/07/16.
//  Copyright © 2016 ivanschuetz. All rights reserved.
//
// swiftlint:disable all
import UIKit

extension CGPoint {

    func distance(_ point: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(x) - Float(point.x), Float(y) - Float(point.y)))
    }

    func add(_ point: CGPoint) -> CGPoint {
        return offset(x: point.x, y: point.y)
    }

    func substract(_ point: CGPoint) -> CGPoint {
        return offset(x: -point.x, y: -point.y)
    }

    func offset(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint { // swiftlint:disable:this identifier_name
        return CGPoint(x: self.x + x, y: self.y + y)
    }

    func surroundingRect(_ size: CGFloat) -> CGRect {
        return CGRect(x: x - size / 2, y: y - size / 2, width: size, height: size)
    }

    func nearest(_ intersections: [CGPoint]) -> (distance: CGFloat, point: CGPoint)? {
        return nearest(intersections, pointMapper: {$0}).map {(distance: $0.distance, point: $0.pointMappable)}
    }
    func nearest<T>(_ pointMappables: [T], pointMapper: (T) -> CGPoint) -> (distance: CGFloat, pointMappable: T)? {
        var minDistancePoint: (distance: CGFloat, pointMappable: T)?
        for pointMappable in pointMappables {
            let dist = distance(pointMapper(pointMappable))
            if (minDistancePoint.map {dist < $0.0}) ?? true {
                minDistancePoint = (dist, pointMappable)
            }
        }
        return minDistancePoint
    }

    func multiplyBy(_ value:CGFloat) -> CGPoint {
        return CGPoint(x: x * value, y: y * value)
    }

    func length() -> CGFloat {
        return CGFloat(sqrt(CDouble(
            x * x + y * y
        )))
    }

    func normalize() -> CGPoint {
        let l = length() // swiftlint:disable:this identifier_name
        return CGPoint(x: x / l, y: y / l)
    }
}
