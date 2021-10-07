//
//  LocalizableBundle.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import Foundation

enum LocalizableBundle: String {
    
    case homeTitle
    
    case firstOnboardingMessage
    case firstOnboardingAnimation
    case secondOnboardingMessage
    case secondOnboardingAnimation
    case thirdOnboardingMessage
    case thirdOnboardingAnimation
    
    case mascotImage
    case lettersImage
    case searchButtonTitle
    case mascotHomeAnimation
    case messageResult
    case mascotResultAnimation
    
    // MARK: - UserDefaults
    case userDefautlsKeySound
    
    // MARK: - Icons
    case activatedSoundIcon
    case disabledSoundIcon
    case searchButtonIcon
    case homeButtonIcon
    case nextButtonIcon
    case previewButtonIcon
    case doneButtonIcon
    
    // MARK: - Game View Message
    case findAnotherPlaceMessage
 
    var localize: String {
        return rawValue.localize(bundle: Bundle(for: HomeViewController.self))
    }
}
