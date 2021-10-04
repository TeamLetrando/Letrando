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
        let gameViewController = gameSceneFactory.instantiateGameViewController()
        navigationController.pushViewController(gameViewController, animated: true)
    }
}
