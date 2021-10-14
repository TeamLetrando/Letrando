//
//  OnboardingSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation

protocol OnboardingFactory {
    func instantiateOnboardingViewController() -> OnboardingViewController
}

class OnboardingSceneFactory: OnboardingFactory {
    func instantiateOnboardingViewController() -> OnboardingViewController {
        return OnboardingViewController()
    }
}
