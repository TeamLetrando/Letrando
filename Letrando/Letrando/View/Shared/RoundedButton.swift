//
//  RoundedButton.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 20/09/21.
//

import UIKit

class RoundedButton: UIButton {
    
    private var selectedImage: String?
    private var disabledImage: String?
    
    override var buttonType: UIButton.ButtonType {
        .roundedRect
    }
   
    convenience init(image: UIImage?) {
        self.init()
        tintColor = .greenActionLetrando
        setBackgroundImage(image, for: .normal)
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        addTarget(self, action: #selector(setAudio), for: .touchUpInside)
    }
    
    @objc private func setAudio() {
        UserDefaults.standard.set(!Sounds.checkAudio(), forKey:LocalizableBundle.userDefautlsKeySound.localize)
        
        Sounds.checkAudio() ? Sounds.playAudio() : Sounds.audioFinish()
      //  updateButtonSoundImage(Sounds.checkAudio())
    }
}
