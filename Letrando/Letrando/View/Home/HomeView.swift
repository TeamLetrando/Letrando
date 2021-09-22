//
//  HomeView.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import Lottie
import UIKit

class HomeView: UIView, ViewCodable {

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
        let animation = AnimationView(name: LocalizableBundle.mascotHomeAnimation.localize)
        animation.frame = superview?.frame ?? .zero
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 0.8
        animation.play()
        return animation
    }()
    
    private lazy var lettersImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: LocalizableBundle.lettersImage.localize)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var searchButton: RoundedButton = {
        let buttonImage = UIImage(systemName: LocalizableBundle.searchButtonIcon.localize)
        let button = RoundedButton(backgroundImage: buttonImage,
                                   buttonAction: startGame,
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
        addSubview(titleLabel)
        addSubview(searchButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            soundButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            soundButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            soundButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13),
            soundButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13),
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            
            searchButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            searchButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            searchButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),

            lettersImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            lettersImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            lettersImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            lettersImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
    }
    
    func setupAditionalChanges() {
        backgroundColor = .lightGreenBackgroundLetrando
    }
 
    @objc private func startGame() {
        delegate?.startGame()
    }
}
