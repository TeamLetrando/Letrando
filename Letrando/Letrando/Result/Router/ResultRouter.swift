//
//  ResultRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol ResultRouterLogic {
    init(gameSceneFactory: GameFactory, homeSceneFatory: HomeFactory, navigationController: UINavigationController)
    func startGame()
    func exitGame()
}

class ResultRouter: ResultRouterLogic {
    required init(gameSceneFactory: GameFactory, homeSceneFatory: HomeFactory,
                  navigationController: UINavigationController) {
        //
    }
    
    func startGame() {
        //
    }
    
    func exitGame() {
        //
    }
    
}
