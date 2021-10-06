//
//  ResultRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol ResultRouterLogic {
    init(gameSceneFactory: GameFactory, navigationController: UINavigationController)
    func startGame()
    func exitGame()
}

class ResultRouter: ResultRouterLogic {
    
    private let navigationController: UINavigationController
    private let gameSceneFactory: GameFactory
    
    required init(gameSceneFactory: GameFactory, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.gameSceneFactory = gameSceneFactory
    }
    
    func startGame() {
        navigationController.popToViewController(gameSceneFactory.instantiateGameViewController(), animated: true)
    }
    
    func exitGame() {
        navigationController.popToRootViewController(animated: true)
    }
    
}
