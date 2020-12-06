//
//  ChartViewSelector.swift
//  SwiftCharts
//
//  Created by ischuetz on 24/08/16.
//  Copyright © 2016 ivanschuetz. All rights reserved.
//
// swiftlint:disable all
import UIKit

/// Updates a UIView for selected / deselected state
public protocol ChartViewSelector {
    
    func displaySelected(_ view: UIView, selected: Bool)
}
