//
//  SearchResultViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import Lottie
import AVFoundation
import ARKit

class SearchResultViewController: UIViewController {
 
    var wordResult: String?
   
    private lazy var resultView = ResultView(wordResult: wordResult ?? String())
    
    convenience init(wordResult: String) {
        self.init()
        self.wordResult = wordResult
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.delegate = self
    }
    
    override func loadView() {
        self.view = resultView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Sounds.reproduceSound(string: wordResult ?? String())
        configSounds()
    }
    
    private func configSounds() {
        Sounds.checkAudio() ? Sounds.playAudio() : Sounds.audioFinish()
    }
}

extension SearchResultViewController: ResultViewDelegate {
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
