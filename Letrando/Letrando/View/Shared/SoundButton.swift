//
//  SoundButton.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 20/09/21.
//

import UIKit
import SoundsKit

class SoundButton: UIView, ViewCodable {
    
    private var userDefaults = UserDefaults.standard
  
    private var currentBackgroundImage: UIImage? {
       // let isFirstLaunch = (userDefaults.value(forKey: UserDefaultsKey.firstSound.rawValue) as? Bool) ?? false
        if userDefaults.bool(forKey: UserDefaultsKey.firstLaunch.rawValue) {
            return UIImage(named: ImageAssets.activatedSound.rawValue)
        } else {
            let buttonSoundImage = SoundsKit.audioIsOn() ? ImageAssets.disabledSound.rawValue :
            ImageAssets.activatedSound.rawValue
            return UIImage(named: buttonSoundImage)
        }
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
        
        SoundsKit.audioIsOn() ? try? SoundsKit.playBackgroundLetrando() :  SoundsKit.stop()
        
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
