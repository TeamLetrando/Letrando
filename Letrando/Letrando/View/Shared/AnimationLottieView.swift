//
//  AnimationLottieView.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 21/09/21.
//

import UIKit
import Lottie

class AnimationLottieView: UIView, ViewCodable {
   
    private lazy var animationName = String()
    
    private lazy var animationView: AnimationView = {
        let animation = AnimationView(name: animationName)
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 0.8
        animation.play()
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    convenience init(named: String) {
        self.init()
        self.animationName = named
    }
    
    override func didMoveToSuperview() {
        setupView()
    }
    
    func buildViewHierarchy() {
        addSubview(animationView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
