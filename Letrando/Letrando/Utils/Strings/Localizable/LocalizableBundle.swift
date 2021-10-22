//
//  LocalizableBundle.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import Foundation

enum LocalizableBundle: String {
    
    case homeTitle
    case onboardingMessagePresentation
    case onboardingMessageAlert
    case onboardingMessageInstruction
    case searchButtonTitle
    case messageResult
    case findAnotherPlaceMessage
 
    var localize: String {
        return rawValue.localize(bundle: Bundle(for: HomeViewController.self))
    }
}
