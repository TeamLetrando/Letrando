//
//  ResultSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import Foundation
import UIKit

class ResultSceneFactory: SceneFactory {
    
    private var navigationController: UINavigationController?
    private var wordResult: String?
    private var resultRouter: ResultRouterLogic?
    private var resultView: ResultViewProtocol?
    private var resultViewController: ResultViewControllerProtocol?
    
    convenience init(navigationController: UINavigationController?, wordResult: String?,
                     gameSceneFactory: GameSceneFactory) {
        self.init(navigationController: navigationController)
        self.navigationController = navigationController
        self.wordResult = wordResult
        resultRouter = ResultRouter(navigationController: navigationController)
               resultRouter?.gameSceneFactory = gameSceneFactory
    }
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
 
    func instantiateViewController() -> UIViewController {
        resultView = nil
        resultViewController = nil
        
        resultView = ResultView(wordResult: wordResult ?? String())
        resultViewController = ResultViewController()
        resultViewController?.setup(with: resultView, resultRouter: resultRouter)
        resultViewController?.modalPresentationStyle = .fullScreen
        return resultViewController ?? UIViewController()
    }
}
