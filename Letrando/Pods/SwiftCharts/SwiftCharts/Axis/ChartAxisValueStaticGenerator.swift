//
//  ChartAxisValuesGenerator.swift
//  swift_charts
//
//  Created by ischuetz on 12/04/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//
// swiftlint:disable all

import UIKit

public typealias ChartAxisValueStaticGenerator = (Double) -> ChartAxisValue

/// Dynamic axis values generation
public struct ChartAxisValuesStaticGenerator {
    public static func generateXAxisValuesWithChartPoints(_ chartPoints: [ChartPoint], minSegmentCount: Double, maxSegmentCount: Double, multiple: Double = 10, axisValueGenerator: ChartAxisValueStaticGenerator, addPaddingSegmentIfEdge: Bool) -> [ChartAxisValue] {
        return generateAxisValuesWithChartPoints(chartPoints, minSegmentCount: minSegmentCount, maxSegmentCount: maxSegmentCount, multiple: multiple, axisValueGenerator: axisValueGenerator, addPaddingSegmentIfEdge: addPaddingSegmentIfEdge, axisPicker: {$0.x})
    }
    public static func generateYAxisValuesWithChartPoints(_ chartPoints: [ChartPoint], minSegmentCount: Double, maxSegmentCount: Double, multiple: Double = 10, axisValueGenerator: ChartAxisValueStaticGenerator, addPaddingSegmentIfEdge: Bool) -> [ChartAxisValue] {
        return generateAxisValuesWithChartPoints(chartPoints, minSegmentCount: minSegmentCount, maxSegmentCount: maxSegmentCount, multiple: multiple, axisValueGenerator: axisValueGenerator, addPaddingSegmentIfEdge: addPaddingSegmentIfEdge, axisPicker: {$0.y})
    }
    fileprivate static func generateAxisValuesWithChartPoints(_ chartPoints: [ChartPoint], minSegmentCount: Double, maxSegmentCount: Double, multiple: Double = 10, axisValueGenerator: ChartAxisValueStaticGenerator, addPaddingSegmentIfEdge: Bool, axisPicker: (ChartPoint) -> ChartAxisValue) -> [ChartAxisValue] {

        let sortedChartPoints = chartPoints.sorted {(obj1, obj2) in
            return axisPicker(obj1).scalar < axisPicker(obj2).scalar
        }

        if let first = sortedChartPoints.first, let last = sortedChartPoints.last {
            return generateAxisValuesWithChartPoints(axisPicker(first).scalar, last: axisPicker(last).scalar, minSegmentCount: minSegmentCount, maxSegmentCount: maxSegmentCount, multiple: multiple, axisValueGenerator: axisValueGenerator, addPaddingSegmentIfEdge: addPaddingSegmentIfEdge)

        } else {
            print("Trying to generate Y axis without datapoints, returning empty array")
            return []
        }
    }

    fileprivate static func generateAxisValuesWithChartPoints(_ first: Double, last lastPar: Double, minSegmentCount: Double, maxSegmentCount: Double, multiple: Double, axisValueGenerator: ChartAxisValueStaticGenerator, addPaddingSegmentIfEdge: Bool) -> [ChartAxisValue] {
        precondition(multiple > 0, "Invalid multiple: \(multiple)")

        guard lastPar >=~ first else {fatalError("Invalid range generating axis values")}

        let last = lastPar =~ first ? lastPar + 1 : lastPar

        // The first axis value will be less than or equal to the first scalar value, aligned with the desired multiple
        var firstValue = first - (first.truncatingRemainder(dividingBy: multiple))
        var lastValue = last + (abs(multiple - last).truncatingRemainder(dividingBy: multiple))
        var segmentSize = multiple

        if firstValue =~ first && addPaddingSegmentIfEdge {
            firstValue -= segmentSize
        }
        if lastValue =~ last && addPaddingSegmentIfEdge {
            lastValue += segmentSize
        }

        let distance = lastValue - firstValue
        var currentMultiple = multiple
        var segmentCount = distance / currentMultiple

        // Find the optimal number of segments and segment width

        // If the number of segments is greater than desired, make each segment wider
        while segmentCount > maxSegmentCount {
            currentMultiple *= 2
            segmentCount = distance / currentMultiple
        }
        segmentCount = ceil(segmentCount)

        // Increase the number of segments until there are enough as desired
        while segmentCount < minSegmentCount {
            segmentCount += 1
        }
        segmentSize = currentMultiple

        // Generate axis values from the first value, segment size and number of segments
        let offset = firstValue
        return (0...Int(segmentCount)).map {segment in
            let scalar = offset + (Double(segment) * segmentSize)
            return axisValueGenerator(scalar)
        }
    }

}
