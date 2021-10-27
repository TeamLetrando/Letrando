//
//  HomeView.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import Lottie
import UIKit

protocol HomeViewDelegate: AnyObject {
    func startGame()
    func showHelp()
}

protocol HomeViewProtocol: UIView {
    var delegate: HomeViewDelegate? { get set }
}

class HomeView: UIView, ViewCodable, HomeViewProtocol {

    weak var delegate: HomeViewDelegate?
   
    private lazy var soundButton: SoundButton = {
        let button = SoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableBundle.homeTitle.localize
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.textColor = .customBrown
        label.font = .set(size: 34, weight: .bold, textStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mascotAnimation: AnimationView = {
        let animation = AnimationView(name: JsonAnimations.mascotHomeAnimation.rawValue)
        animation.frame = superview?.frame ?? .zero
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 0.8
        animation.play()
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    private lazy var lettersImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageAssets.lettersHome.rawValue)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var playButton: RoundedButton = {
        let buttonImage = UIImage(systemName: SystemIcons.play.rawValue)
        let button = RoundedButton(backgroundImage: buttonImage,
                                   buttonAction: startGame,
                                   tintColor: .greenActionLetrando)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var helpButton: RoundedButton = {
        let buttonImage = UIImage(systemName: SystemIcons.help.rawValue)
        let button = RoundedButton(backgroundImage: buttonImage,
                                   buttonAction: showHelp,
                                   tintColor: .greenActionLetrando)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func didMoveToSuperview() {
        setupView()
    }
    
    func buildViewHierarchy() {
        addSubview(lettersImage)
        addSubview(mascotAnimation)
        addSubview(soundButton)
        addSubview(helpButton)
        addSubview(titleLabel)
        addSubview(playButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            soundButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            soundButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            soundButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13),
            soundButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13),
            
            helpButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            helpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            helpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13),
            helpButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13),
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            
            playButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            playButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            lettersImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            lettersImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            lettersImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            lettersImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            mascotAnimation.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            mascotAnimation.bottomAnchor.constraint(equalTo: lettersImage.topAnchor, constant: 50),
            mascotAnimation.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mascotAnimation.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
    }
    
    func setupAditionalChanges() {
        backgroundColor = .lightGreenBackgroundLetrando
    }
 
    private func startGame() {
        delegate?.startGame()
    }
    
    private func showHelp() {
        delegate?.showHelp()
    }
}
