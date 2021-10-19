//
//  GameSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

class GameSceneFactory: SceneFactory {
  
    private lazy var randomWord = JsonData().randomWord()
    private let navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func instantiateViewController() -> UIViewController {
        let gameViewController = SearchViewController(wordGame: randomWord)
        gameViewController.setup(with: instatiateGameView(), gameRouter: instantiateGameRouter())
        
        return gameViewController
    }
    
    private func instatiateGameView() -> GameView {
        return GameView(letters: randomWord?.breakInLetters())
    }
    
    private func instantiateGameRouter() -> GameRouterLogic {
        return GameRouter(wordResult: randomWord?.word, navigationController: navigationController)
    }
   
}
