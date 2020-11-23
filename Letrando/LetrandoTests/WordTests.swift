//
//  WordTests.swift
//  LetrandoTests
//
//  Created by Ronaldo Gomes on 23/11/20.
//

import XCTest
@testable import Letrando

class WordTests: XCTestCase {

    func test_breakWordsInLetters_wordBola_returnBolaSeparated() {
        //Given
        let sut = Word(word: "Bola")

        //When
        let wordBreak = sut.breakInLetters()

        //Then
        XCTAssertEqual(wordBreak, ["B", "o", "l", "a"])
    }

}
