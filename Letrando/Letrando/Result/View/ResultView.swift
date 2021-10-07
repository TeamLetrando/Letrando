//
//  ResultView.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 17/09/21.
//

import UIKit

protocol ResultViewDelegate: AnyObject {
    func restartGame()
    func exitGame()
}

protocol ResultViewProtocol: UIView {
    var delegate: ResultViewDelegate? { get set }
    init(wordResult: String)
}

class ResultView: UIView, ViewCodable, ResultViewProtocol {
    
    weak var delegate: ResultViewDelegate?
    private lazy var wordResult = String()
    
    private lazy var soundButton: SoundButton = {
        let button = SoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var resultMessageLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableBundle.messageResult.localize
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.textColor = .customBrown
        label.font = .set(size: 34, weight: .bold, textStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var wordResultLabel: UILabel = {
        let label = UILabel()
        label.text = wordResult.uppercased()
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.textColor = .darkGreenLetrando
        label.font = .set(size: 40, weight: .bold, textStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var animationView: AnimationLottieView = {
        let view = AnimationLottieView(named: LocalizableBundle.mascotResultAnimation.localize)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchButton: RoundedButton = {
        let backgroundImage = UIImage(systemName: LocalizableBundle.searchButtonIcon.localize)
        let button = RoundedButton(backgroundImage: backgroundImage,
                                   buttonAction: restartGame,
                                   tintColor: .greenActionLetrando)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var exitButton: RoundedButton = {
        let backgroundImage = UIImage(systemName: LocalizableBundle.homeButtonIcon.localize)
        let button = RoundedButton(backgroundImage: backgroundImage,
                                   buttonAction: exitGame,
                                   tintColor: .customBrown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    required convenience init(wordResult: String) {
        self.init()
        self.wordResult = wordResult
    }
    
    override func didMoveToSuperview() {
        setupView()
    }
    
    func buildViewHierarchy() {
        addSubview(soundButton)
        addSubview(resultMessageLabel)
        addSubview(wordResultLabel)
        addSubview(animationView)
        addSubview(searchButton)
        addSubview(exitButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            soundButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            soundButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            soundButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13),
            soundButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13),
            
            resultMessageLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            resultMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            resultMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            resultMessageLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            
            wordResultLabel.topAnchor.constraint(equalTo: resultMessageLabel.bottomAnchor, constant: 5),
            wordResultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            wordResultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            wordResultLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
           
            searchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            searchButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            searchButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            searchButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            exitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            exitButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            exitButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            exitButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            animationView.topAnchor.constraint(equalTo: wordResultLabel.bottomAnchor, constant: 12),
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            animationView.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -12)
        ])
    }
    
    func setupAditionalChanges() {
        backgroundColor = .lightGreenBackgroundLetrando
    }
    
    private func restartGame() {
        delegate?.restartGame()
    }
    
    private func exitGame() {
        delegate?.exitGame()
    }
}
