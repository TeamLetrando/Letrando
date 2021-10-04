//
//  MainRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation
import UIKit

protocol MainRouterLogic {
    
    init(scene: UIWindowScene, homeSceneFatory: HomeFactory)
    func startHome()
}

class MainRouter: MainRouterLogic {
    
    private let navigationController = UINavigationController()
    private var window: UIWindow?
    private var homeSceneFactory: HomeFactory
    
    required init(scene: UIWindowScene, homeSceneFatory: HomeFactory = HomeSceneFactory()) {
        window = UIWindow(windowScene: scene)
        homeSceneFactory = HomeSceneFactory()
    }
    
    func startHome() {
        navigationController.isNavigationBarHidden = true
        let homeView = homeSceneFactory.instantiateHomeView()
        let homeViewController = homeSceneFactory.instantiateHomeViewControler()
       
        navigationController.viewControllers = [homeViewController]
        homeViewController.setup(with: homeView,
                                 homeRouter: HomeRouter(alertSceneFactory: AlertSceneFatory(),
                                                        navigationController: navigationController))
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
