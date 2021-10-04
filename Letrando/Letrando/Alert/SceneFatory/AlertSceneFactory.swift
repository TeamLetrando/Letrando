//
//  AlertSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation

protocol AlertFactory {
    func instantiateAlertViewController() -> AlertViewController
}

class AlertSceneFatory: AlertFactory {
    func instantiateAlertViewController() -> AlertViewController {
        return AlertViewController()
    }
}
