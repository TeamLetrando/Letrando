//
//  JsonDataTests.swift
//  LetrandoTests
//
//  Created by Kellyane Nogueira on 23/11/20.
//

import XCTest
@testable import Letrando

class JsonDataTests: XCTestCase {

    override func setUpWithError() throws {
        // This method is called before the invocation of each test method in the class.
    }

    func test_readLocalFile_readingLocalFile_returnNotNil() {
        // Given
        let sut = JsonData()
        // When
        let result = sut.readLocalFile()
        // Then
        XCTAssertNotNil(result)
    }

    func test_parse_decodingJson_returnNotEqual() {
        // Given
        let sut = JsonData()
        // When
        let result = sut.parse()
        // Then
        XCTAssertFalse(result.isEmpty)
    }

    func test_randomWord_randomizingwords_returnNotNil() {
        // Given
        let sut = JsonData()
        // When
        let result = sut.randomWord()
        // Then
        XCTAssertNotNil(result)
    }

}
