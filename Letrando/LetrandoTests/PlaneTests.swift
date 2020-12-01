//
//  PlaneTests.swift
//  LetrandoTests
//
//  Created by Lidiane Gomes Barbosa on 27/11/20.
//

import Foundation
import XCTest
import SceneKit
import ARKit
@testable import Letrando

class PlaneTests: XCTestCase {
    func test_plane_inicializationIsWorking() {
        //given
        let newAnchor = ARAnchor(name: "test", transform: simd_float4x4.init())
        let newPlaneAnchor = ARPlaneAnchor(anchor: newAnchor)
        let sut = Plane(newPlaneAnchor)

        //when
        let planeAnchor = sut.planeAnchor
        let planeGeometry = sut.planeGeometry
        let planeNode = sut.planeNode
        let shadowPlaneGeometry = sut.shadowPlaneGeometry
        let shadowNode = sut.shadowNode

        //then
        XCTAssertNotNil(planeAnchor)
        XCTAssertNotNil(planeGeometry)
        XCTAssertNotNil(planeNode)
        XCTAssertNotNil(shadowPlaneGeometry)
        XCTAssertNotNil(shadowNode)

    }

    func test_planeUpdate() {
        //given
        let anchor = ARAnchor(name: "test", transform: simd_float4x4.init())
        let planeAnchor = ARPlaneAnchor(anchor: anchor)
        let sut = Plane(planeAnchor)

        let sutPlaneAnchor = sut.planeAnchor

        //when
        let newAnchor = ARAnchor(name: "test2", transform: simd_float4x4.init())
        let newPlaneAnchor = ARPlaneAnchor(anchor: newAnchor)
        sut.update(newPlaneAnchor)

        let newSutPlaneAnchor = sut.planeAnchor
        //then
        XCTAssertNotEqual(sutPlaneAnchor, newSutPlaneAnchor)

    }
}
