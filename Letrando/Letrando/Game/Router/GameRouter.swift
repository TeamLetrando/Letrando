//
//  GameRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol GameRouterLogic {
    init(resultSceneFactory: ResultFactory, wordResult: String?, navigationController: UINavigationController)
    func startResult()
    func backToHome()
}

class GameRouter: GameRouterLogic {
    
    private var resultSceneFactory: ResultFactory
    private var navigationController: UINavigationController
    private var wordResult = String()
    
    required init(resultSceneFactory: ResultFactory, wordResult: String?,
                  navigationController: UINavigationController) {
        self.resultSceneFactory = resultSceneFactory
        self.navigationController = navigationController
        self.wordResult = wordResult ?? String()
    }
    
    func startResult() {
        let resultView = resultSceneFactory.instantiateResultView()
        let resultViewController = resultSceneFactory.instantiateResultViewController()
        let resultRouter = ResultRouter(gameSceneFactory: GameSceneFactory(),
                                        navigationController: navigationController)
        
        resultViewController.setup(with: resultView, wordResult: wordResult, resultRouter: resultRouter)
        navigationController.pushViewController(resultViewController, animated: true)
    }
    
    func backToHome() {
        navigationController.popToRootViewController(animated: true)
    }
}
