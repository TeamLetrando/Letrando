//
//  MainRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation
import UIKit

protocol MainRouterLogic {
    init(scene: UIWindowScene, homeSceneFatory: SceneFactory, navigationController: UINavigationController)
    func startHome()
}

class MainRouter: MainRouterLogic {
    
    private var navigationController: UINavigationController
    private var window: UIWindow?
    private var homeSceneFactory: SceneFactory
    
    required init(scene: UIWindowScene, homeSceneFatory: SceneFactory, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeSceneFactory = homeSceneFatory
        window = UIWindow(windowScene: scene)
    }
    
    func startHome() {
        let homeViewController = homeSceneFactory.instantiateViewController()
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [homeViewController]
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
