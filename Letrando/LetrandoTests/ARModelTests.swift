//
//  ARModelTests.swift
//  LetrandoTests
//
//  Created by Ronaldo Gomes on 22/11/20.
//

import XCTest
@testable import Letrando

class ARModelTests: XCTestCase {

    func test_configureText_returnNotNil() {
        //Given
        let str = "Bola"
        //When
        let scnText = ARModel.configureText(str)

        XCTAssertNotNil(scnText)
    }

    func test_createTextNode_returnNotNil() {
        //Given
        let str = "Bola"

        //When
        let scnNode = ARModel.createTextNode(string: str)

        //Then
        XCTAssertNotNil(scnNode)
    }
}
