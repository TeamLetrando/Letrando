//
//  ARModel.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import Foundation
import SceneKit

class ARModel {

    var word: Word?

    func transformWordInSCNText() -> [SCNText] {
        guard let word = word else {
            return []
        }
        let scnTexts = word.breakInLetters().map {
            SCNText(string: $0.uppercased(), extrusionDepth: 0.5)
        }
        return scnTexts
    }
}
