//
//  JsonData.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 23/11/20.
//

import Foundation

//Load json
//Create parse method

class JsonData {

    let name = "words"

    func readLocalFile() -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {

                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }

    func parse() -> [Word] {

        guard let jsonData = readLocalFile() else { return [] }
        do {
            let decodedData = try JSONDecoder().decode([Word].self, from: jsonData)

            return decodedData

        } catch {
            return []
        }
    }

    func randomWord() -> Word? {
        guard let word = parse().randomElement() else { return nil }
        return word
    }

}
