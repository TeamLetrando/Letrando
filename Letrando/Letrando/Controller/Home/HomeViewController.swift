//
//  HomeViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import Lottie
import AVFoundation

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.delegate = self
        configSounds()
    }
}

extension HomeViewController: HomeViewDelegate {
    
    func configSounds() {
        if Sounds.checkAudio() {
            Sounds.playAudio()
        } else {
            Sounds.audioFinish()
        }
    }
    
    func startGame() {
        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "alert")
                as? AlertViewController else {fatalError()}
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    } 
}
