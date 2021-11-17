//
//  HomeViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import Lottie
import SoundsKit

protocol HomeViewControllerProtocol: UIViewController {
    func setup(with view: HomeViewProtocol, homeRouter: HomeRouterLogic)
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {
    
    private var homeView: HomeViewProtocol?
    private var homeRouter: HomeRouterLogic?
    private var userDefaults = UserDefaults.standard
  
    func setup(with view: HomeViewProtocol, homeRouter: HomeRouterLogic) {
        self.homeView = view
        self.homeRouter = homeRouter
    }
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView?.delegate = self
        setUserDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configSounds()
    }
    
    private func configSounds() {
        SoundsKit.audioIsOn() ? try? SoundsKit.playBackgroundLetrando() : SoundsKit.stop()
            userDefaults.set(false, forKey: UserDefaultsKey.firstSound.rawValue)
    }
    
    private func setUserDefaults() {
        if userDefaults.object(forKey: UserDefaultsKey.onboarding.rawValue) == nil {
            userDefaults.set(false, forKey: UserDefaultsKey.onboarding.rawValue)
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    
    func showHelp() {
        homeRouter?.startOnboarding()
    }
    
    func startGame() {
        homeRouter?.startGame()
    }
}
