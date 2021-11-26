//
//  OnboardingRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import UIKit
import SoundsKit

protocol OnboardingRouterLogic: AnyObject {
    init(navigationController: UINavigationController?)
    func dismissOnboarding()
}

class OnboardingRouter: OnboardingRouterLogic {
    
    private var navigationController: UINavigationController?
    private var userDefaults = UserDefaults.standard
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func dismissOnboarding() {
        SoundsKit.audioIsOn() ? SoundsKit.stop() : try? SoundsKit.playBackgroundLetrando()
        userDefaults.set(false, forKey: UserDefaultsKey.onboardingIsOn.rawValue)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
