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
    func setup(with view: HomeViewProtocol?, homeRouter: HomeRouterLogic?)
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {
    
    private weak var homeView: HomeViewProtocol?
    private weak var homeRouter: HomeRouterLogic?
    private var userDefaults = UserDefaults.standard
    
    func setup(with view: HomeViewProtocol?, homeRouter: HomeRouterLogic?) {
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
        setOrientation()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
 
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setOrientation() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.myOrientation = .portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configSounds()
        setOrientation()
    }
    
    private func configSounds() {
        if userDefaults.bool(forKey: UserDefaultsKey.firstLaunchHome.rawValue) {
            SoundsKit.audioIsOn() ? try? SoundsKit.playBackgroundLetrando() : SoundsKit.stop()
            userDefaults.set(false, forKey: UserDefaultsKey.firstLaunchHome.rawValue)
        }
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
