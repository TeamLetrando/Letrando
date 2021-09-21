//
//  RoundedButton.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 20/09/21.
//

import UIKit

class RoundedButton: UIButton {
    
    private lazy var backgroundImage: UIImage? = UIImage()
    private lazy var buttonAction: (() -> Void) = {}
   
    convenience init(backgroundImage: UIImage?, buttonAction: @escaping (() -> Void), tintColor: UIColor) {
        self.init()
        self.backgroundImage = backgroundImage
        self.buttonAction = buttonAction
        self.tintColor = tintColor
        self.backgroundColor = .white
        addTarget(self, action: #selector(setButtonAction), for: .touchUpInside)
        self.setBackgroundImage(backgroundImage, for: .normal)
    }
 
    @objc func setButtonAction() {
        buttonAction()
        animateButton()
    }

    override func setNeedsLayout() {
        layer.borderWidth = frame.width * 0.1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
    }
    
    private func animateButton() {
        let center = self.center
        UIView.animate(withDuration: 0.5, animations: {
            self.frame.size.width -= 3
            self.frame.size.height -= 3
            self.center = center
        })
    }
}
