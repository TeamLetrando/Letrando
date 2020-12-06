//
//  ChartCandleStickLayer.swift
//  SwiftCharts
//
//  Created by ischuetz on 28/04/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//
// swiftlint:disable all

import UIKit

open class ChartCandleStickLayer<T: ChartPointCandleStick>: ChartPointsLayer<T> {

    fileprivate var screenItems: [CandleStickScreenItem] = []

    fileprivate let itemWidth: CGFloat
    fileprivate let strokeWidth: CGFloat
    fileprivate let increasingColor: UIColor
    fileprivate let decreasingColor: UIColor
    public init(xAxis: ChartAxis, yAxis: ChartAxis, chartPoints: [T], itemWidth: CGFloat = 10, strokeWidth: CGFloat = 1, increasingColor: UIColor = UIColor.black, decreasingColor: UIColor = UIColor.white) {
        self.itemWidth = itemWidth
        self.strokeWidth = strokeWidth
        self.increasingColor = increasingColor
        self.decreasingColor = decreasingColor
        super.init(xAxis: xAxis, yAxis: yAxis, chartPoints: chartPoints)
    }

    open override func chartInitialized(chart: Chart) {
        super.chartInitialized(chart: chart)

        self.screenItems = generateScreenItems()
    }
    override open func chartContentViewDrawing(context: CGContext, chart: Chart) {
        for screenItem in screenItems {
            context.setLineWidth(strokeWidth)
            context.setStrokeColor(UIColor.black.cgColor)
            context.move(to: CGPoint(x: screenItem.x, y: screenItem.lineTop))
            context.addLine(to: CGPoint(x: screenItem.x, y: screenItem.lineBottom))
            context.strokePath()

            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
            context.setFillColor(screenItem.fillColor.cgColor)
            context.fill(screenItem.rect)
            context.stroke(screenItem.rect)
        }
    }

    fileprivate func generateScreenItems() -> [CandleStickScreenItem] {
        return chartPointsModels.map {model in

            let chartPoint = model.chartPoint
            let x = model.screenLoc.x // swiftlint:disable:this identifier_name

            let highScreenY = modelLocToScreenLoc(x: Double(x), y: Double(chartPoint.high)).y
            let lowScreenY = modelLocToScreenLoc(x: Double(x), y: Double(chartPoint.low)).y
            let openScreenY = modelLocToScreenLoc(x: Double(x), y: Double(chartPoint.open)).y
            let closeScreenY = modelLocToScreenLoc(x: Double(x), y: Double(chartPoint.close)).y
            let (rectTop, rectBottom, fillColor) = closeScreenY < openScreenY ? (closeScreenY, openScreenY, self.increasingColor) : (openScreenY, closeScreenY, self.decreasingColor)
            return CandleStickScreenItem(x: x, lineTop: highScreenY, lineBottom: lowScreenY, rectTop: rectTop, rectBottom: rectBottom, width: itemWidth, fillColor: fillColor)
        }
    }
    override func updateChartPointsScreenLocations() {
        super.updateChartPointsScreenLocations()
        screenItems = generateScreenItems()
    }
}

private struct CandleStickScreenItem {
    let x: CGFloat // swiftlint:disable:this identifier_name
    let lineTop: CGFloat
    let lineBottom: CGFloat
    let fillColor: UIColor
    let rect: CGRect
    init(x: CGFloat, lineTop: CGFloat, lineBottom: CGFloat, rectTop: CGFloat, rectBottom: CGFloat, width: CGFloat, fillColor: UIColor) { // swiftlint:disable:this identifier_name
        self.x = x
        self.lineTop = lineTop
        self.lineBottom = lineBottom
        self.rect = CGRect(x: x - (width / 2), y: rectTop, width: width, height: rectBottom - rectTop)
        self.fillColor = fillColor
    }
}

// swiftlint:enable all
