//
//  ResultRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol ResultRouterLogic {
    init(homeRouter: HomeRouterLogic, navigationController: UINavigationController?)
    func restartGame()
    func exitGame()
}

class ResultRouter: ResultRouterLogic {
    
    private let navigationController: UINavigationController?
    private let homeRouter: HomeRouterLogic
    
    required init(homeRouter: HomeRouterLogic, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.homeRouter = homeRouter
    }
    
    func restartGame() {
        homeRouter.startGame()
        navigationController?.dismiss(animated: true)
    }
    
    func exitGame() {
        navigationController?.dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
}
