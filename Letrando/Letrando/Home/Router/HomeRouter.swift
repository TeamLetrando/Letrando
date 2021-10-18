//
//  HomeRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation
import UIKit

protocol HomeRouterLogic {
    init(onboardingSceneFactory: SceneFactory,
         gameSceneFactory: SceneFactory, navigationController: UINavigationController?)
    func startOnboarding()
    func startGame()
}

class HomeRouter: HomeRouterLogic {
    
    private var gameSceneFactory: SceneFactory
    private var onboardingSceneFactory: SceneFactory
    private var navigationController: UINavigationController?
    private var onboardingKey = "onboarding"
    
    required init(onboardingSceneFactory: SceneFactory,
                  gameSceneFactory: SceneFactory, navigationController: UINavigationController?) {
        self.onboardingSceneFactory = onboardingSceneFactory
        self.gameSceneFactory = gameSceneFactory
        self.navigationController = navigationController
    }
    
    func startOnboarding() {
        let onboardingViewController = onboardingSceneFactory.instantiateViewController()
        navigationController?.present(onboardingViewController, animated: true)
    }
    
    func startGame() {
        let gameViewController = gameSceneFactory.instantiateViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
        
        if !UserDefaults.standard.bool(forKey: onboardingKey) {
            startOnboarding()
            UserDefaults.standard.set(true, forKey: onboardingKey)
        }
    }
}
