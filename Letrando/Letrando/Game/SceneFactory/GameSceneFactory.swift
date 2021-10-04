//
//  GameSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol GameFactory {
    func instantiateGameViewController() -> SearchViewController
}

class GameSceneFactory: GameFactory {
    
    func instantiateGameViewController() -> SearchViewController {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let gameViewController =  storyboard.instantiateViewController(identifier: "search")
                as? SearchViewController else {fatalError()}
        return gameViewController
    }
}
