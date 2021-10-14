//
//  HomeRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation
import UIKit

protocol HomeRouterLogic {
    init(onboardingSceneFactory: OnboardingFactory,
         gameSceneFactory: GameFactory, navigationController: UINavigationController)
    func startOnboarding()
    func startGame()
}

class HomeRouter: HomeRouterLogic {
    
    private var gameSceneFactory: GameFactory
    private var onboardingSceneFactory: OnboardingFactory
    private var navigationController: UINavigationController
    
    required init(onboardingSceneFactory: OnboardingFactory,
                  gameSceneFactory: GameFactory, navigationController: UINavigationController) {
        self.onboardingSceneFactory = onboardingSceneFactory
        self.gameSceneFactory = gameSceneFactory
        self.navigationController = navigationController
    }
    
    func startOnboarding() {
        let onboardingViewController = onboardingSceneFactory.instantiateOnboardingViewController()
        let onboardingRouter = OnboardingRouter(navigationController: navigationController)
        onboardingViewController.setup(onboardingRouter: onboardingRouter)
      
        onboardingViewController.isModalInPresentation = true
        navigationController.present(onboardingViewController, animated: true)
    }
    
    func startGame() {
        let gameView = gameSceneFactory.instatiateGameView()
        let gameViewController = gameSceneFactory.instantiateGameViewController()
        let gameRouter = GameRouter(resultSceneFactory: ResultSceneFactory(),
                                    wordResult: gameSceneFactory.randomWord?.word,
                                    navigationController: navigationController)
        
        gameViewController.setup(with: gameView, gameRouter: gameRouter)
        navigationController.pushViewController(gameViewController, animated: true)
    }
}
