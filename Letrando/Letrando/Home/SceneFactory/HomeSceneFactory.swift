//
//  HomeSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation
import UIKit

protocol HomeFactory {

    func instantiateHomeView() -> HomeViewProtocol
    func instantiateHomeViewControler() -> HomeViewControllerProtocol
}

class HomeSceneFactory: HomeFactory {
    
    func instantiateHomeView() -> HomeViewProtocol {
        return HomeView()
    }
    
    func instantiateHomeViewControler() -> HomeViewControllerProtocol {
        return HomeViewController()
    }
}
