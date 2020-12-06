//
//  Operators.swift
//  SwiftCharts
//
//  Created by ischuetz on 16/07/16.
//  Copyright © 2016 ivanschuetz. All rights reserved.
//

import Foundation

infix operator =~ : ComparisonPrecedence

func =~ (a: Float, b: Float) -> Bool { // swiftlint:disable:this identifier_name
    return fabsf(a - b) < Float.ulpOfOne
}

func =~ (a: CGFloat, b: CGFloat) -> Bool { // swiftlint:disable:this identifier_name
    return abs(a - b) < CGFloat.ulpOfOne
}

func =~ (a: Double, b: Double) -> Bool { // swiftlint:disable:this identifier_name
    return fabs(a - b) < Double.ulpOfOne
}

infix operator !=~ : ComparisonPrecedence

func !=~ (a: Float, b: Float) -> Bool { // swiftlint:disable:this identifier_name
    return !(a =~ b)
}

func !=~ (a: CGFloat, b: CGFloat) -> Bool { // swiftlint:disable:this identifier_name
    return !(a =~ b)
}

func !=~ (a: Double, b: Double) -> Bool { // swiftlint:disable:this identifier_name
    return !(a =~ b)
}

infix operator <=~ : ComparisonPrecedence

func <=~ (a: Float, b: Float) -> Bool { // swiftlint:disable:this identifier_name
    return a =~ b || a < b
}

func <=~ (a: CGFloat, b: CGFloat) -> Bool { // swiftlint:disable:this identifier_name
    return a =~ b || a < b
}

func <=~ (a: Double, b: Double) -> Bool { // swiftlint:disable:this identifier_name
    return a =~ b || a < b
}

infix operator >=~ : ComparisonPrecedence

func >=~ (a: Float, b: Float) -> Bool { // swiftlint:disable:this identifier_name
    return a =~ b || a > b
}

func >=~ (a: CGFloat, b: CGFloat) -> Bool { // swiftlint:disable:this identifier_name
    return a =~ b || a > b
}

func >=~ (a: Double, b: Double) -> Bool { // swiftlint:disable:this identifier_name
    return a =~ b || a > b
}
