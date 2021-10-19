//
//  SoundButton.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 20/09/21.
//

import UIKit

class SoundButton: UIView, ViewCodable {
  
    private var currentBackgroundImage: UIImage? {
        let buttonSoundImage = Sounds.checkAudio() ? ImageAssets.activatedSoundImage.rawValue :
                ImageAssets.disabledSoundImage.rawValue
        
        return UIImage(named: buttonSoundImage)
    }
    
    private lazy var roundedButton: RoundedButton = {
        let button = RoundedButton(backgroundImage: currentBackgroundImage,
                                   buttonAction: setAudio,
                                   tintColor: .greenActionLetrando)
        button.setBackgroundImage(currentBackgroundImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func didMoveToSuperview() {
        setupView()
    }
    
    @objc private func setAudio() {
        UserDefaults.standard.set(!Sounds.checkAudio(), forKey: UserDefaultsKey.backgroundMusic.rawValue)
        
        Sounds.checkAudio() ? Sounds.playAudio() : Sounds.audioFinish()
        
        roundedButton.setBackgroundImage(currentBackgroundImage, for: .normal)
        layoutSubviews()
    }
    
    func buildViewHierarchy() {
        addSubview(roundedButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            roundedButton.topAnchor.constraint(equalTo: topAnchor),
            roundedButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            roundedButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            roundedButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
