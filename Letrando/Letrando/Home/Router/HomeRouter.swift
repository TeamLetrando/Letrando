//
//  HomeRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation
import UIKit

protocol HomeRouterLogic {
    init(navigationController: UINavigationController?)
    func startOnboarding()
    func startGame()
}

class HomeRouter: HomeRouterLogic {
    
    private var gameSceneFactory: SceneFactory
    private var onboardingSceneFactory: SceneFactory
    private var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        onboardingSceneFactory = OnboardingSceneFactory(navigationController: navigationController)
        gameSceneFactory = GameSceneFactory(navigationController: navigationController)
    }
   
    func startOnboarding() {
        let onboardingViewController = onboardingSceneFactory.instantiateViewController()
        navigationController?.present(onboardingViewController, animated: true)
    }
    
    func startGame() {
        let gameViewController = gameSceneFactory.instantiateViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
        
        if !UserDefaults.standard.bool(forKey: UserDefaultsKey.onboarding.rawValue) {
            startOnboarding()
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.onboarding.rawValue)
        }
    }
}
