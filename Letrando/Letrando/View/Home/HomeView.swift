//
//  HomeView.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import Lottie
import UIKit

class HomeView: UIView, ViewCodable {
    
    let labelFontSize = CGFloat(32)
    let animationSpeed = CGFloat(0.8)
    
    weak var delegate: HomeViewDelegate?
   
    private lazy var configButton: UIButton = {
        let button = UIButton()
        button.tintColor = .greenActionLetrando
        button.setBackgroundImage(UIImage(systemName: LocalizableBundle.configButtonIcon.localize), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showConfig), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableBundle.homeTitle.localize
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.textColor = .customBrown
        label.font = .set(size: labelFontSize, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mascotAnimation: AnimationView = {
        let animation = AnimationView(name: LocalizableBundle.mascotHomeAnimation.localize)
        animation.frame = superview?.frame ?? .zero
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = animationSpeed
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
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .greenActionLetrando
        button.setTitle(LocalizableBundle.searchButtonTitle.localize, for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .set(size: labelFontSize, weight: .bold)
        button.addTarget(self, action: #selector(search), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func didMoveToSuperview() {
        setupView()
    }
    
    func buildViewHierarchy() {
        addSubview(configButton)
        addSubview(titleLabel)
        addSubview(lettersImage)
        addSubview(mascotAnimation)
        addSubview(searchButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            configButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            configButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            configButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            configButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            
            searchButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchButton.bottomAnchor.constraint(equalTo: bottomAnchor),

            lettersImage.bottomAnchor.constraint(equalTo: searchButton.topAnchor),
            lettersImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            lettersImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            lettersImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
        ])
    }
    
    func setupAditionalChanges() {
        backgroundColor = .lightGreenBackgroundLetrando
    }
    
    @objc private func showConfig() {
        delegate?.showConfigurations()
    }
    
    @objc private func search() {
        delegate?.startGame()
    }
}
