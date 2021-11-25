//
//  GameRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit
import SoundsKit

protocol GameRouterLogic: AnyObject {
    init(wordResult: String?, navigationController: UINavigationController?, gameSceneFactory: GameSceneFactory)
    func startResult()
    func backToHome()
}

class GameRouter: GameRouterLogic {
    
    private var resultSceneFactory: SceneFactory
    private var navigationController: UINavigationController?
    private var wordResult: String
    
    required init(wordResult: String?, navigationController: UINavigationController?,
                  gameSceneFactory: GameSceneFactory) {
        self.navigationController = navigationController
        self.wordResult = wordResult ?? String()
        resultSceneFactory = ResultSceneFactory(navigationController: navigationController,
                                                wordResult: wordResult, gameSceneFactory: gameSceneFactory)
    }
    
    func startResult() {
        let resultViewController = resultSceneFactory.instantiateViewController()
        navigationController?.present(resultViewController, animated: true)
    }
 
    func backToHome() {
        SoundsKit.setKeyAudio(true)
        navigationController?.popToRootViewController(animated: true)
    }
}
