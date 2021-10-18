//
//  GameRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol GameRouterLogic {
    init(resultSceneFactory: SceneFactory, wordResult: String?, navigationController: UINavigationController?)
    func startResult()
    func backToHome()
}

class GameRouter: GameRouterLogic {
    
    private var resultSceneFactory: SceneFactory
    private var navigationController: UINavigationController?
    private var wordResult = String()
    
    required init(resultSceneFactory: SceneFactory, wordResult: String?,
                  navigationController: UINavigationController?) {
        self.resultSceneFactory = resultSceneFactory
        self.navigationController = navigationController
        self.wordResult = wordResult ?? String()
    }
    
    func startResult() {
        let resultViewController = resultSceneFactory.instantiateViewController()
        navigationController?.present(resultViewController, animated: true)
    }
    
    func backToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
}
