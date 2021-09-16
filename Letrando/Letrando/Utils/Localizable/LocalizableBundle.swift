//
//  LocalizableBundle.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import Foundation

enum LocalizableBundle: String {
    
    case homeTitle
    case mascotImage
    case lettersImage
    case searchButtonTitle
    case mascotHomeAnimation
    
    // MARK: - UserDefaults
    case userDefautlsKeySound
    
    // MARK: - Icons
    case activatedSoundIcon
    case diabledSoundIcon
 
    var localize: String {
        return rawValue.localize(bundle: Bundle(for: HomeViewController.self))
    }
}
