//
//  Word.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import Foundation

struct Word: Codable {

    let word: String
    let accessFrequency: Int

    func breakInLetters() -> [String] {
        return word.map { String($0).uppercased() }
        // Teste de github action
    }

}
