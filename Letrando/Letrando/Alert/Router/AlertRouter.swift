//
//  AlertRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import UIKit

protocol AlertRouterLogic {
    init(gameSceneFactory: GameFactory, navigationController: UINavigationController)
    func startGame()
}

class AlertRouter: AlertRouterLogic {
    
    private var gameSceneFactory: GameFactory
    private var navigationController: UINavigationController
    
    required init(gameSceneFactory: GameFactory, navigationController: UINavigationController) {
        self.gameSceneFactory = gameSceneFactory
        self.navigationController = navigationController
    }
    
    func startGame() {
        let gameView = gameSceneFactory.instatiateGameView()
        let gameViewController = gameSceneFactory.instantiateGameViewController()
        let gameRouter = GameRouter(resultSceneFactory: ResultSceneFactory(),
                                    wordResult: gameSceneFactory.randomWord?.word,
                                    navigationController: navigationController)
        
        gameViewController.setup(with: gameView, gameRouter: gameRouter)
        navigationController.pushViewController(gameViewController, animated: true)
    }
}
