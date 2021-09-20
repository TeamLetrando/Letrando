//
//  AlertView.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 14/09/21.
//

import UIKit

final class AlertView: UIView, ViewCodable {
    
    private lazy var mascot: UIImageView = {
        let mascot = UIImageView()
        mascot.image = UIImage(named: LocalizableBundle.alertImageName.localize)
        mascot.contentMode = .scaleAspectFit
        mascot.translatesAutoresizingMaskIntoConstraints = false
        return mascot
    }()
    
    private lazy var message: UILabel = {
        let message = UILabel()
        let messageTextStyle = UIFont.TextStyle(rawValue: LocalizableBundle.alertMessage.localize)
        message.text = LocalizableBundle.alertMessage.localize
        message.textAlignment = .center
        message.numberOfLines = 0
        message.font = UIFont.set(size: 32, weight: .bold, textStyle: messageTextStyle)
        message.textColor = .customBrown
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    override func didMoveToSuperview() {
        self.setupView()
    }
    
    func buildViewHierarchy() {
        addSubview(mascot)
        addSubview(message)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mascot.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mascot.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mascot.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            mascot.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),

            message.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            message.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            message.topAnchor.constraint(equalTo: mascot.bottomAnchor, constant: 25),
            message.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func setupAditionalChanges() {
        backgroundColor = UIColor.lightGreenBackgroundLetrando
    }
    
}
