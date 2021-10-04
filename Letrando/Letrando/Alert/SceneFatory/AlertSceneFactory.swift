//
//  AlertSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation

protocol AlertFactory {
    func instantiateAlertViewController() -> AlertViewController
    func instantiateAlertView() -> AlertView
}

class AlertSceneFatory: AlertFactory {
    
    func instantiateAlertView() -> AlertView {
        return AlertView()
    }
    
    func instantiateAlertViewController() -> AlertViewController {
        return AlertViewController()
    }
}
