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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configSounds()
    }
    
    private func configSounds() {
        Sounds.checkAudio() ? Sounds.playAudio() : Sounds.audioFinish()
    }
}

extension HomeViewController: HomeViewDelegate {
    
    func startGame() {
        homeRouter?.startGame()
        homeRouter?.startOnboarding()
    }
}
