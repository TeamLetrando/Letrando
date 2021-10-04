//
//  ResultViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

protocol ResultViewControllerProtocol: UIViewController {
    func setup(with view: ResultViewProtocol, wordResult: String, resultRouter: ResultRouterLogic)
}

class ResultViewController: UIViewController, ResultViewControllerProtocol {

    private lazy var wordResult = String()
   
    private var resultView: ResultViewProtocol?
    private var resultRouter: ResultRouterLogic?
    
    func setup(with view: ResultViewProtocol, wordResult: String, resultRouter: ResultRouterLogic) {
        self.wordResult = wordResult
        self.resultView = view
        self.resultRouter = resultRouter
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
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "home")
                as? HomeViewController else {fatalError()}
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    }
    
    func startGame() {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "search")
                as? SearchViewController else {fatalError()}
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    }
}
