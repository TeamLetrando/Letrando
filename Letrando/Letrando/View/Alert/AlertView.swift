//
//  AlertView.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 14/09/21.
//

import UIKit

final class AlertView: UIView, ViewCodable {
    
    private lazy var mascotAnimation: UIImageView = {
        let mascotAnimation = UIImageView()
        mascotAnimation.image = UIImage(named: LocalizableBundle.alertImageName.localize)
        mascotAnimation.contentMode = .scaleAspectFit
        mascotAnimation.translatesAutoresizingMaskIntoConstraints = false
        return mascotAnimation
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
