//
//  HomeSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 01/10/21.
//

import Foundation
import UIKit

class HomeSceneFactory: SceneFactory {
   
    private let navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func instantiateViewController() -> UIViewController {
        let homeView = instantiateHomeView()
        let homeViewController = HomeViewController()
       
        homeViewController.setup(with: homeView, homeRouter: instantiateHomeRouter())
        return homeViewController
    }
    
    private func instantiateHomeView() -> HomeViewProtocol {
        return HomeView()
    }
    
    private func instantiateHomeRouter() -> HomeRouterLogic {
        return HomeRouter(navigationController: navigationController)
    }
}
