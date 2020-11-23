//
//  Word.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import Foundation

struct Word: Codable {

    let word: String

    func breakInLetters() -> [String] {
        return word.map { String($0) }
    }

}
