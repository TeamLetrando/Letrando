//
//  GameSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol GameFactory {
    var randomWord: Word? { get set }
    func instatiateGameView() -> GameView
    func instantiateGameViewController() -> SearchViewController
}

class GameSceneFactory: GameFactory {

    lazy var randomWord = JsonData().randomWord()
    
    func instatiateGameView() -> GameView {
        return GameView(letters: randomWord?.breakInLetters())
    }
    
    func instantiateGameViewController() -> SearchViewController {
        return SearchViewController(wordGame: randomWord)
    }
}
