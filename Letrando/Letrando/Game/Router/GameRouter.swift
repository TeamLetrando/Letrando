//
//  GameRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol GameRouterLogic {
    init(wordResult: String?, navigationController: UINavigationController?)
    func startResult()
    func backToHome()
}

class GameRouter: GameRouterLogic {
    
    private var resultSceneFactory: SceneFactory
    private var navigationController: UINavigationController?
    private var wordResult: String
    
    required init(wordResult: String?, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.wordResult = wordResult ?? String()
        resultSceneFactory = ResultSceneFactory(navigationController: navigationController, wordResult: wordResult)
    }
    
    func startResult() {
        let resultViewController = resultSceneFactory.instantiateViewController()
        navigationController?.present(resultViewController, animated: true)
    }
    
    func backToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
}
