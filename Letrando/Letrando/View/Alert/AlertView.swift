//
//  AlertView.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 14/09/21.
//

import UIKit

final class AlertView: UIView, ViewCodable {
    
    private let mascot: UIImageView = {
        let mascot = UIImageView()
        mascot.image = UIImage(named: LocalizableBundle.alertImageName.localize)
        mascot.translatesAutoresizingMaskIntoConstraints = false
        return mascot
    }()
    
    private let messageView: UIView = {
        let messageView = UIView()
        messageView.backgroundColor = .lightGreenBackgroundLetrando
        messageView.translatesAutoresizingMaskIntoConstraints = false
        return messageView
    }()
    
    private let message: UILabel = {
        let message = UILabel()
        message.text = LocalizableBundle.alertMessage.localize
        message.textAlignment = .center
        message.numberOfLines = 0
        message.textColor = .customBrown
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    override func didMoveToSuperview() {
        self.setupView()
    }
    
    func buildViewHierarchy() {
        addSubview(mascot)
        addSubview(messageView)
        addSubview(message)
    }
    
    func setupConstraints() {
        mascot.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        mascot.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        mascot.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        mascot.widthAnchor.constraint(greaterThanOrEqualToConstant: 250).isActive = true
        mascot.heightAnchor.constraint(greaterThanOrEqualToConstant: 250).isActive = true

        messageView.topAnchor.constraint(equalTo: mascot.bottomAnchor, constant: 20).isActive = true
        messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        messageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        messageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        messageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 250).isActive = true
        messageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 250).isActive = true

        message.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 20).isActive = true
        message.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -20).isActive = true
        message.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10).isActive = true
        message.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -20).isActive = true
        message.widthAnchor.constraint(greaterThanOrEqualToConstant: 250).isActive = true
        message.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    }
    
    func setupAditionalChanges() {
        backgroundColor = UIColor.lightGreenBackgroundLetrando
    }
    
}
