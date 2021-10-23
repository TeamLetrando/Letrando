//
//  SceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 15/10/21.
//

import Foundation
import UIKit

protocol SceneFactory {
    init(navigationController: UINavigationController?)
    func instantiateViewController() -> UIViewController
}