//
//  AlertView.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 14/09/21.
//

import UIKit
import Lottie

final class AlertView: UIView, ViewCodable {
    
    private lazy var mascotAnimation: AnimationView = {
        let animation = AnimationView(name: LocalizableBundle.alertAnimation.localize)
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 0.8
        animation.play()
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    private lazy var messageAlert: UILabel = {
        let messageAlert = UILabel()
        let messageTextStyle = UIFont.TextStyle(rawValue: LocalizableBundle.alertMessage.localize)
        messageAlert.text = LocalizableBundle.alertMessage.localize
        messageAlert.textAlignment = .center
        messageAlert.numberOfLines = .zero
        messageAlert.font = UIFont.set(size: 32, weight: .bold, textStyle: messageTextStyle)
        messageAlert.textColor = .customBrown
        messageAlert.translatesAutoresizingMaskIntoConstraints = false
        return messageAlert
    }()
    
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
