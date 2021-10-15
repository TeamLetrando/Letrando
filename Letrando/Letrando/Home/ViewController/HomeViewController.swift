//
//  HomeViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import Lottie

protocol HomeViewControllerProtocol: UIViewController {
    func setup(with view: HomeViewProtocol, homeRouter: HomeRouterLogic)
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {
    
    private var homeView: HomeViewProtocol?
    private var homeRouter: HomeRouterLogic?
    private var onboardingKey = "onboarding"
  
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
        Sounds.checkAudio() ? Sounds.playAudio() : Sounds.audioFinish()
    }
    
    private func setUserDefaults() {
        if UserDefaults.standard.object(forKey: onboardingKey) == nil {
            UserDefaults.standard.set(false, forKey: onboardingKey)
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    
    func showHelp() {
        homeRouter?.startOnboarding()
    }
    
    func startGame() {
        homeRouter?.startGame()
        
        if !UserDefaults.standard.bool(forKey: onboardingKey) {
            homeRouter?.startOnboarding()
            UserDefaults.standard.set(true, forKey: onboardingKey)
        }
    }
}
