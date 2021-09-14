//
//  LocalizableBundle.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import Foundation

enum LocalizableBundle: String {
    case homeTile
    
    var localiza: String {
        return rawValue.localize(bundle: Bundle(for: HomeViewController.self))
    }
}
