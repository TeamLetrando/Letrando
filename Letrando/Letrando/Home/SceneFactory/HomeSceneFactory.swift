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
    private var homeView: HomeViewProtocol?
    private var homeRouter: HomeRouterLogic?
    private var homeViewController: HomeViewControllerProtocol?
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        homeRouter = instantiateHomeRouter()
        homeView = instantiateHomeView()
        homeViewController = HomeViewController()
    }
    
    func instantiateViewController() -> UIViewController {
        homeViewController?.setup(with: homeView, homeRouter: homeRouter)
        return homeViewController ?? UIViewController()
    }
    
    private func instantiateHomeView() -> HomeViewProtocol {
        return HomeView()
    }
    
    private func instantiateHomeRouter() -> HomeRouterLogic {
        return HomeRouter(navigationController: navigationController)
    }
}
