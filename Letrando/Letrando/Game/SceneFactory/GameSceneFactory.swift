//
//  GameSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

class GameSceneFactory: SceneFactory {
  
    private var randomWord: Word?
    private let navigationController: UINavigationController?
    private var gameView: GameView?
    private var gameRouter: GameRouterLogic?
    private var gameViewController: GameViewControllerProtocol?
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func instantiateViewController() -> UIViewController {
        randomWord = JsonData().randomWord()
        gameView = nil
        gameRouter = nil
        gameViewController = nil
        
        gameView = instatiateGameView()
        gameRouter = instantiateGameRouter()
        gameViewController = SearchViewController(wordGame: randomWord)
        gameViewController?.setup(with: gameView, gameRouter: gameRouter)
        return gameViewController ?? UIViewController()
    }
    
    private func instatiateGameView() -> GameView {
        return GameView(letters: randomWord?.breakInLetters())
    }
    
    private func instantiateGameRouter() -> GameRouterLogic {
        return GameRouter(wordResult: randomWord?.word,
                          navigationController: navigationController,
                          gameSceneFactory: self)
    }
   
}
