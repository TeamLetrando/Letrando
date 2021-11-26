//
//  OnboardingSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation
import UIKit

class OnboardingSceneFactory: SceneFactory {
    
    private var navigationController: UINavigationController?
    private var onboardingViewController: OnboardingViewController?
    private var onboardingRouter: OnboardingRouterLogic?
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        onboardingRouter = instantiateOnboardingRouter()
        onboardingViewController = OnboardingViewController()
    }
    
    func instantiateViewController() -> UIViewController {
        onboardingViewController?.setup(onboardingRouter: onboardingRouter)
        onboardingViewController?.isModalInPresentation = true
        return onboardingViewController ?? UIViewController()
    }
    
    private func instantiateOnboardingRouter() -> OnboardingRouterLogic {
        return OnboardingRouter(navigationController: navigationController)
    }
}
