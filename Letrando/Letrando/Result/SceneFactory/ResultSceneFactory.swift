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
    
    convenience init(navigationController: UINavigationController?, wordResult: String?) {
        self.init(navigationController: navigationController)
        self.navigationController = navigationController
        self.wordResult = wordResult
    }
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func instantiateViewController() -> UIViewController {
        let resultView = instantiateResultView()
        let resultViewController = ResultViewController()
        resultViewController.setup(with: resultView, resultRouter: instantiateResultRouter())
      
        resultViewController.modalPresentationStyle = .fullScreen
        return resultViewController
    }
    
    private func instantiateResultRouter() -> ResultRouterLogic {
        return ResultRouter(navigationController: navigationController)
    }
    
    private func instantiateResultView() -> ResultViewProtocol {
        return ResultView(wordResult: wordResult ?? String())
    }
}
