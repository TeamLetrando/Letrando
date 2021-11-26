//
//  ResultRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol ResultRouterLogic: AnyObject {
    init(navigationController: UINavigationController?)
    func restartGame()
    func exitGame()
    var gameSceneFactory: SceneFactory? { get set }
}

class ResultRouter: ResultRouterLogic {
    weak var gameSceneFactory: SceneFactory?
    private let navigationController: UINavigationController?

    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func restartGame() {
        let gameViewController = gameSceneFactory?.instantiateViewController()
        navigationController?.popToRootViewController(animated: true)
        navigationController?.pushViewController(gameViewController ?? UIViewController(), animated: true)
        navigationController?.dismiss(animated: true)
    }
    
    func exitGame() {
        navigationController?.dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
}
