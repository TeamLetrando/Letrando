//
//  Interpolatable.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/14/19.
//swiftlint:disable all

import Foundation
import CoreGraphics

protocol Interpolatable {

  func interpolateTo(_ to: Self,
                     amount: CGFloat,
                     spatialOutTangent: CGPoint?,
                     spatialInTangent: CGPoint?) -> Self
  
}
