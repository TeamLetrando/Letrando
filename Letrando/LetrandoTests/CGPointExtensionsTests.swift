//
//  CGPointExtensionsTests.swift
//  LetrandoTests
//
//  Created by Lidiane Gomes Barbosa on 27/11/20.
//

import XCTest
import UIKit
@testable import Letrando
class CGPointExtensionsTests: XCTestCase {

    func test_generateRandomPoint_returnValueBetweenValues() {
        let sut = CGPoint.generateRandomPoint()
        let pointX = sut.x
        let pointY = sut.y

        XCTAssertTrue(pointX >= -1000 && pointX <= 1000)
        XCTAssertTrue(pointY >= -1000 && pointY <= 1000)
    }

    func test_distance_returnDistanceBetweenTwoPoints() {
        let pointOne = CGPoint(x: 0, y: 1)
        let pointTwo = CGPoint(x: 2, y: -4)
        let respost = CGFloat(5.385164807134504)

        let distance = pointOne.distance(to: pointTwo)

        XCTAssertEqual(distance, respost)

    }
    func test_isPointValid_returnTrue() {
        let pointOne = CGPoint(x: 100, y: 10)
        let pointTwo = CGPoint(x: -20, y: -400)
        let pointThree = CGPoint(x: 400, y: 285)

        let points = [pointTwo, pointThree]

        let respost = pointOne.isPointValid(array: points)

        XCTAssertTrue(respost)

    }

    func test_isPointValid_returnFalse() {
        let pointOne = CGPoint(x: 10, y: 10)
        let pointTwo = CGPoint(x: -20, y: -40)
        let pointThree = CGPoint(x: 40, y: 25)

        let points = [pointTwo, pointThree]

        let respost = pointOne.isPointValid(array: points)

       XCTAssertFalse(respost)

    }

}
