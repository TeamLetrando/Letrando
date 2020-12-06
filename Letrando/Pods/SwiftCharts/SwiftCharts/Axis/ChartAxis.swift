//
//  ChartAxis.swift
//  SwiftCharts
//
//  Created by ischuetz on 25/06/16.
//  Copyright © 2016 ivanschuetz. All rights reserved.
//
// swiftlint:disable all

import UIKit

open class ChartAxis: CustomStringConvertible {

    /// First model value
    open internal(set) var first: Double

    /// Last model value
    open internal(set) var last: Double

    // Screen location (relative to chart view's frame) corresponding to first model value
    open internal(set) var firstScreen: CGFloat

    // Screen location (relative to chart view's frame) corresponding to last model value
    open internal(set) var lastScreen: CGFloat

    open internal(set) var firstVisibleScreen: CGFloat
    open internal(set) var lastVisibleScreen: CGFloat

    public let paddingFirstScreen: CGFloat
    public let paddingLastScreen: CGFloat

    open var fixedPaddingFirstScreen: CGFloat?
    open var fixedPaddingLastScreen: CGFloat?

    open var firstVisible: Double {
        return scalarForScreenLoc(firstVisibleScreen)
    }

    open var lastVisible: Double {
        return scalarForScreenLoc(lastVisibleScreen)
    }

    open var zoomFactor: Double {
        guard visibleLength != 0 else {return 1}
        return abs(length / visibleLength)
    }

    // The space between first and last model values. Can be negative (used for mirrored axes)
    open var length: Double {
        fatalError("override")
    }

    // The space between first and last screen locations. Can be negative (used for mirrored axes)
    open var screenLength: CGFloat {
        fatalError("override")
    }

    open var screenLengthInit: CGFloat {
        fatalError("override")
    }

    open var visibleLength: Double {
        fatalError("override")
    }

    open var visibleScreenLength: CGFloat {
        fatalError("override")
    }

    open var screenToModelRatio: CGFloat {
        return screenLength / CGFloat(length)
    }

    open var modelToScreenRatio: CGFloat {
        return CGFloat(length) / screenLength
    }

    var firstInit: Double
    var lastInit: Double
    var firstScreenInit: CGFloat
    var lastScreenInit: CGFloat

    public required init(first: Double, last: Double, firstScreen: CGFloat, lastScreen: CGFloat, paddingFirstScreen: CGFloat = 0, paddingLastScreen: CGFloat = 0, fixedPaddingFirstScreen: CGFloat? = nil, fixedPaddingLastScreen: CGFloat? = nil) {
        self.first = first
        self.last = last
        self.firstInit = first
        self.lastInit = last
        self.firstScreen = firstScreen
        self.lastScreen = lastScreen
        self.firstScreenInit = firstScreen
        self.lastScreenInit = lastScreen
        self.paddingFirstScreen = paddingFirstScreen
        self.paddingLastScreen = paddingLastScreen
        self.fixedPaddingFirstScreen = fixedPaddingFirstScreen
        self.fixedPaddingLastScreen = fixedPaddingLastScreen
        self.firstVisibleScreen = firstScreen
        self.lastVisibleScreen = lastScreen

        adjustModelBoundariesForPadding()
    }

    open func screenLocForScalar(_ scalar: Double) -> CGFloat {
        fatalError("Override")
    }

    open func scalarForScreenLoc(_ screenLoc: CGFloat) -> Double {
        fatalError("Override")
    }

    func internalScreenLocForScalar(_ scalar: Double) -> CGFloat {
        return CGFloat(scalar - first) * screenToModelRatio
    }
    open func innerScreenLocForScalar(_ scalar: Double) -> CGFloat {
        fatalError("Override")
    }

    open func innerScalarForScreenLoc(_ screenLoc: CGFloat) -> Double {
        fatalError("Override")
    }

    func zoom(_ x: CGFloat, y: CGFloat, centerX: CGFloat, centerY: CGFloat, elastic: Bool) { // swiftlint:disable:this identifier_name
        fatalError("Override")
    }

    func zoom(_ scaleX: CGFloat, scaleY: CGFloat, centerX: CGFloat, centerY: CGFloat, elastic: Bool) {
        fatalError("Override")
    }

    func pan(_ deltaX: CGFloat, deltaY: CGFloat, elastic: Bool) {
        fatalError("Override")
    }

    open var transform: (scale: CGFloat, translation: CGFloat) {
        return (scale: CGFloat(zoomFactor), translation: firstScreenInit - firstScreen)
    }

    func offsetFirstScreen(_ offset: CGFloat) {
        firstScreen += offset
        firstScreenInit += offset
        firstVisibleScreen += offset

        adjustModelBoundariesForPadding()
    }

    func offsetLastScreen(_ offset: CGFloat) {
        lastScreen += offset
        lastScreenInit += offset
        lastVisibleScreen += offset

        adjustModelBoundariesForPadding()
    }

    open func screenToModelLength(_ screenLength: CGFloat) -> Double {
        return scalarForScreenLoc(screenLength) - scalarForScreenLoc(0)
    }

    open func modelToScreenLength(_ modelLength: Double) -> CGFloat {
        return screenLocForScalar(modelLength) - screenLocForScalar(0)
    }

    open var firstModelValueInBounds: Double {
        fatalError("Overrode")
    }

    open var lastModelValueInBounds: Double {
        fatalError("Overrode")
    }

    open var description: String {
        return "{\(type(of: self)), first: \(first), last: \(last), firstInit: \(firstInit), lastInit: \(lastInit), zoomFactor: \(zoomFactor), firstScreen: \(firstScreen), lastScreen: \(lastScreen), firstVisible: \(firstVisible), lastVisible: \(lastVisible), firstVisibleScreen: \(firstVisibleScreen), lastVisibleScreen: \(lastVisibleScreen), paddingFirstScreen: \(paddingFirstScreen), paddingLastScreen: \(paddingLastScreen), length: \(length), screenLength: \(screenLength), firstModelValueInBounds: \(firstModelValueInBounds), lastModelValueInBounds: \(lastModelValueInBounds))}"
    }

    var innerRatio: Double {
        return (lastInit - firstInit) / Double(screenLengthInit - paddingFirstScreen - paddingLastScreen)
    }

    func toModelInner(_ screenLoc: CGFloat) -> Double {
        fatalError("Override")
    }

    func isInBoundaries(_ screenCenter: CGFloat, screenSize: CGSize) -> Bool {
        fatalError("Override")
    }

    func keepInBoundaries() {
        fatalError("Override")
    }
    fileprivate func adjustModelBoundariesForPadding() {
        if paddingFirstScreen != 0 || paddingLastScreen != 0 {
            first = toModelInner(firstScreenInit)
            last = toModelInner(lastScreenInit)
        }
    }
    open func copy(_ first: Double? = nil, last: Double? = nil, firstScreen: CGFloat? = nil, lastScreen: CGFloat? = nil, paddingFirstScreen: CGFloat? = nil, paddingLastScreen: CGFloat? = nil, fixedPaddingFirstScreen: CGFloat? = nil, fixedPaddingLastScreen: CGFloat? = nil) -> ChartAxis {
        return type(of: self).init(
            first: first ?? self.first,
            last: last ?? self.last,
            firstScreen: firstScreen ?? self.firstScreen,
            lastScreen: lastScreen ?? self.lastScreen,
            paddingFirstScreen: paddingFirstScreen ?? self.paddingFirstScreen,
            paddingLastScreen: paddingLastScreen ?? self.paddingLastScreen,
            fixedPaddingFirstScreen:  fixedPaddingFirstScreen ?? self.fixedPaddingFirstScreen,
            fixedPaddingLastScreen:  fixedPaddingLastScreen ?? self.fixedPaddingLastScreen
        )
    }
}
