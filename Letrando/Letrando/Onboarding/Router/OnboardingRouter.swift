//
//  OnboardingRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import UIKit

protocol OnboardingRouterLogic {
    init(navigationController: UINavigationController?)
    func dismissOnboarding()
}

class OnboardingRouter: OnboardingRouterLogic {
    
    private var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func dismissOnboarding() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
