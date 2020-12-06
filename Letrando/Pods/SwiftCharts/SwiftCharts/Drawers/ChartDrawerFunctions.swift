//
//  ChartDrawerFunctions.swift
//  Examples
//
//  Created by ischuetz on 21/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//
// swiftlint:disable all
import UIKit

func ChartDrawLine(context: CGContext, p1: CGPoint, p2: CGPoint, width: CGFloat, color: UIColor) { // swiftlint:disable:this identifier_name
    context.setStrokeColor(color.cgColor)
    context.setLineWidth(width)
    context.move(to: CGPoint(x: p1.x, y: p1.y))
    context.addLine(to: CGPoint(x: p2.x, y: p2.y))
    context.strokePath()
}

func ChartDrawDottedLine(context: CGContext, p1: CGPoint, p2: CGPoint, width: CGFloat, color: UIColor, dotWidth: CGFloat, dotSpacing: CGFloat) { // swiftlint:disable:this identifier_name
    context.setStrokeColor(color.cgColor)
    context.setLineWidth(width)
    context.setLineDash(phase: 0, lengths: [dotWidth, dotSpacing])
    context.move(to: CGPoint(x: p1.x, y: p1.y))
    context.addLine(to: CGPoint(x: p2.x, y: p2.y))
    context.strokePath()
    context.setLineDash(phase: 0, lengths: [])
}
