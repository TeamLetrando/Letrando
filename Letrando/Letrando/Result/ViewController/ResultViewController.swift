//
//  ResultViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

protocol ResultViewControllerProtocol: UIViewController {
    func setup(with view: ResultViewProtocol, resultRouter: ResultRouterLogic)
}

class ResultViewController: UIViewController, ResultViewControllerProtocol {

    private lazy var wordResult = String()
    private var resultView: ResultViewProtocol?
    private var resultRouter: ResultRouterLogic?
    
    func setup(with view: ResultViewProtocol, resultRouter: ResultRouterLogic) {
        self.resultView = view
        self.resultRouter = resultRouter
        self.wordResult = resultView?.wordResult ?? String()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView?.delegate = self
    }
    
    override func loadView() {
        self.view = resultView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Sounds.reproduceSound(string: wordResult)
        configSounds()
    }
    
    private func configSounds() {
        Sounds.checkAudio() ? Sounds.playAudio() : Sounds.audioFinish()
    }
}

extension ResultViewController: ResultViewDelegate {
    func exitGame() {
        resultRouter?.exitGame()
    }
    
    func restartGame() {
        resultRouter?.restartGame()
    }
}
