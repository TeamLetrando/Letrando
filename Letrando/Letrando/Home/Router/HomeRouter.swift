//
//  HomeRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation
import UIKit

protocol HomeRouterLogic {
    init(alertSceneFactory: AlertFactory, navigationController: UINavigationController)
    func startAlert()
}

class HomeRouter: HomeRouterLogic {
    
    private var alertSceneFactory: AlertFactory
    private var navigationController: UINavigationController
    
    required init(alertSceneFactory: AlertFactory, navigationController: UINavigationController) {
        self.alertSceneFactory = alertSceneFactory
        self.navigationController = navigationController
    }
    
    func startAlert() {
        let alertViewController = alertSceneFactory.instantiateAlertViewController()
        navigationController.pushViewController(alertViewController, animated: true)
    }

}
