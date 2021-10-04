//
//  GameRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol GameRouterLogic {
    init(resultSceneFactory: ResultFactory, wordResult: String, navigationController: UINavigationController)
    func startResult()
}

class GameRouter: GameRouterLogic {
    
    required init(resultSceneFactory: ResultFactory, wordResult: String, navigationController: UINavigationController) {
        //
    }
    
    func startResult() {
        //
    }
}
