//
//  ResultRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import UIKit

protocol ResultRouterLogic {
    init(alertRouter: AlertRouterLogic, navigationController: UINavigationController)
    func restartGame()
    func exitGame()
}

class ResultRouter: ResultRouterLogic {
    
    private let navigationController: UINavigationController
    private let alertRouter: AlertRouterLogic
    
    required init(alertRouter: AlertRouterLogic, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.alertRouter = alertRouter
    }
    
    func restartGame() {
        alertRouter.startGame()
        navigationController.dismiss(animated: true)
    }
    
    func exitGame() {
        navigationController.dismiss(animated: true)
        navigationController.popToRootViewController(animated: true)
    }
    
}
