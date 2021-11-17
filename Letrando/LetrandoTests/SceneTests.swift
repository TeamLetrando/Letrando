//
//  SceneTests.swift
//  LetrandoTests
//
//  Created by Lidiane Gomes Barbosa on 27/11/20.
//

import Foundation
import XCTest
import SceneKit
@testable import Letrando

class SceneTests: XCTestCase {

    func test_scene_isNotNil() {
        let sut = Scene()

        let scene = sut.scene

       XCTAssertNotNil(scene)
    }

//    func test_textNode_isNotEmpty() {
//        //given
//        var sut = Scene()
//        let parent = SCNNode()
//        let position = SCNVector3Zero
//        let letter = "C"
//
//        //when
//        sut.addLetterToScene(letter: letter, parent: parent, position: position)
//        let result = sut.textNode
//
//        //then
//        XCTAssertNotEqual(result, [])
//    }

}
