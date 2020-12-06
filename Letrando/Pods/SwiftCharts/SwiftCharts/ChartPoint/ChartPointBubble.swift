//
//  ChartPointBubble.swift
//  Examples
//
//  Created by ischuetz on 17/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//
// swiftlint:disable all
import UIKit

open class ChartPointBubble: ChartPoint {
    public let diameterScalar: Double
    public let bgColor: UIColor
    public let borderColor: UIColor
    
    public init(x: ChartAxisValue, y: ChartAxisValue, diameterScalar: Double, bgColor: UIColor, borderColor: UIColor = UIColor.black) { // swiftlint:disable:this identifier_name
        self.diameterScalar = diameterScalar
        self.bgColor = bgColor
        self.borderColor = borderColor
        super.init(x: x, y: y)
    }

    required public init(x: ChartAxisValue, y: ChartAxisValue) { // swiftlint:disable:this identifier_name
        fatalError("init(x:y:) has not been implemented")
    }
}
