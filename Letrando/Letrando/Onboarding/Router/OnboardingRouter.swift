//
//  OnboardingRouter.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import UIKit
import SoundsKit

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
        SoundsKit.stop()
        SoundsKit.file = "Curious_Kiddo"
        SoundsKit.fileExtension = "mp3"
        SoundsKit.audioIsOn() ? try? SoundsKit.play() : SoundsKit.stop()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
