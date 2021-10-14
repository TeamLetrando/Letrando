//
//  AlertView.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 14/09/21.
//

import UIKit
import Lottie

protocol PageViewDelegate: AnyObject {
    func startAnimation()
}

final class PageView: UIView, ViewCodable {
    
    private lazy var animationName = String()
    private lazy var message = String()
    
    fileprivate lazy var mascotAnimation: AnimationView = {
        let animation = AnimationView(name: animationName)
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 0.8
        animation.play()
        animation.backgroundBehavior = .pauseAndRestore
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    private lazy var messageAlert: UILabel = {
        let messageAlert = UILabel()
        messageAlert.text = message
        messageAlert.textAlignment = .center
        messageAlert.numberOfLines = .zero
        messageAlert.font = UIFont.set(size: 28, weight: .bold, textStyle: .largeTitle)
        messageAlert.textColor = .customBrown
        messageAlert.translatesAutoresizingMaskIntoConstraints = false
        return messageAlert
    }()
    
    convenience init(animationName: String, message: String) {
        self.init()
        self.animationName = animationName
        self.message = message
    }
    
    override func didMoveToSuperview() {
        setupView()
    }
    
    func buildViewHierarchy() {
        addSubview(mascotAnimation)
        addSubview(messageAlert)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mascotAnimation.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mascotAnimation.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mascotAnimation.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            mascotAnimation.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),

            messageAlert.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageAlert.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageAlert.topAnchor.constraint(equalTo: mascotAnimation.bottomAnchor, constant: 25),
            messageAlert.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func setupAditionalChanges() {
        backgroundColor = .lightGreenBackgroundLetrando
    }
}

extension PageView: PageViewDelegate {
    
    func startAnimation() {
        mascotAnimation.play()
        layoutIfNeeded()
    }
}
