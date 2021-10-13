//
//  HomeViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    private lazy var homeView = HomeView()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.delegate = self
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
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.modalPresentationStyle = .fullScreen
        self.present(onboardingViewController, animated: true, completion: nil)
    } 
}
