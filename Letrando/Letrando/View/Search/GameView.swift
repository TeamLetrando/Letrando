//
//  GameView.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 14/09/21.
//

import UIKit
import ARKit

class GameView: UIView, ViewCodable {
    weak var delegate: GameControlerDelegate?
    
    private lazy var findAnotherPlaceMessageLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableBundle.findAnotherPlaceMessage.localize
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "BubblegumSans-Regular", size: 28)
        label.backgroundColor = .greenActionLetrando
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lettersStackView: LettersStackView = {
        let stack = LettersStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var feedbackGenerator =  UIImpactFeedbackGenerator(style: .medium)
    
    private lazy var handButton: RoundedButton = {
        let button = RoundedButton(backgroundImage: UIImage(named: "handButtonOn"),
                                   buttonAction: handButtonAction,
                                   tintColor: .greenActionLetrando)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backToHomeButton: UIButton = {
        let button = RoundedButton(backgroundImage: UIImage(named: "back"),
                                   buttonAction: backToHomeButtonAction,
                                   tintColor: .greenActionLetrando)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var letters: [String]? {
        didSet {
            lettersStackView.letters = letters
        }
    }
    
    private lazy var dogSearchingImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: LocalizableBundle.mascotSearchingImage.localize)
        image.contentMode = .scaleAspectFit
        dogSearchingImageView.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    
    override func didMoveToSuperview() {
        setupView()
    }
    
    func buildViewHierarchy() {
        addSubview(backToHomeButton)
        addSubview(handButton)
        addSubview(findAnotherPlaceMessageLabel)
        addSubview(lettersStackView)
        addSubview(dogSearchingImageView)
    }
    
    func setupConstraints() {
        let letterStackHeightConstraint = lettersStackView.heightAnchor.constraint(equalToConstant: 58 * Multipliers.height)
        letterStackHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            backToHomeButton.heightAnchor.constraint(equalToConstant: 50 * Multipliers.height),
            backToHomeButton.widthAnchor.constraint(equalToConstant: 50 * Multipliers.height),
            backToHomeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                  constant: 16 * Multipliers.height),
            backToHomeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16 * Multipliers.widht),
            
            handButton.heightAnchor.constraint(equalToConstant: 50 * Multipliers.height),
            handButton.widthAnchor.constraint(equalToConstant: 50 * Multipliers.height),
            handButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16 * Multipliers.height),
            handButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16 * Multipliers.widht),
            
            findAnotherPlaceMessageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            findAnotherPlaceMessageLabel.topAnchor.constraint(equalTo: backToHomeButton.bottomAnchor,
                                                              constant: 20 * Multipliers.height),
            findAnotherPlaceMessageLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            letterStackHeightConstraint,
            lettersStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lettersStackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40),
            lettersStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            
            dogSearchingImageView.heightAnchor.constraint(equalToConstant: 100 * Multipliers.height),
            dogSearchingImageView.widthAnchor.constraint(equalToConstant: 100 * Multipliers.widht),
            dogSearchingImageView.rightAnchor.constraint(equalTo: leftAnchor),
            dogSearchingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dogSearchingImageView.topAnchor.constraint(equalTo: findAnotherPlaceMessageLabel.bottomAnchor, constant: 20 * Multipliers.height),
            dogSearchingImageView.bottomAnchor.constraint(equalTo: lettersStackView.topAnchor, constant: -20 * Multipliers.height)
        ])
    }
    
    func setupAditionalChanges() {
        feedbackGenerator.prepare()
        handButtonAction()
    }
    
    func feedbackGeneratorImpactOccurred() {
        feedbackGenerator.impactOccurred()
    }
    
    @objc private func handButtonAction() {
        if let isAnimationEnable = UserDefaults.standard.object(forKey: "showAnimationFeedback") as? Bool {
            UserDefaults.standard.setValue(!isAnimationEnable, forKey: "showAnimationFeedback")
            setHandButtonImage(for: isAnimationEnable ? "handButtonOn" : "handButtonOff")
        }
    }
    
    @objc private func backToHomeButtonAction() {
        delegate?.backToHome()
    }
    
    private func dogSearchingImageViewAnimation() {
        let topDog = dogSearchingImageView.topAnchor.constraint(equalTo: findAnotherPlaceMessageLabel.bottomAnchor, constant: 20 * Multipliers.height)
        let bottomDog = dogSearchingImageView.bottomAnchor.constraint(equalTo: lettersStackView.topAnchor, constant: -20 * Multipliers.height)
        UIView.animate(withDuration: 2.0) { [weak self] in
            NSLayoutConstraint.activate([topDog,bottomDog])
            self?.layoutIfNeeded()
        }
    }
}

extension GameView: GameViewDelegate {
    func changeMessageLabelHiding(for value: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.findAnotherPlaceMessageLabel.isHidden = value
            if !value {
                self?.dogSearchingImageViewAnimation()
            }
            
        }
    }
    
    func changeLettersStackHiding(for value: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.lettersStackView.isHidden = value
        }
    }
    
    func animateFeedBack(initialPosition: CGPoint, letter: String, sceneView: ARSCNView) {
        if !((UserDefaults.standard.object(forKey: "showAnimationFeedback") as? Bool ?? false) == false) {
            return
        }
        
        lettersStackView.subviews.forEach {
            if let letterImageView = $0 as? UIImageView,
               let letterName = letterImageView.layer.name,
               letterName == letter {

                let finalPosition = lettersStackView.convert(letterImageView.layer.position, to: sceneView)
                
                let handImage = UIImageView(frame: CGRect(x: initialPosition.x,
                                                          y: initialPosition.y,
                                                          width: 50,
                                                          height: 80))
                handImage.image = UIImage(named: "hand")
                
                sceneView.addSubview(handImage)
                
                UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
                    handImage.layer.position = finalPosition
                } completion: { _ in
                    handImage.removeFromSuperview()
                }
            }
        }
    }
    
    func setHandButtonImage(for imageName: String) {
        DispatchQueue.main.async { [weak self] in
            self?.handButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
}
 
enum Multipliers {
    static let screenSize = UIScreen.main.bounds.size
    static let height = UIScreen.main.bounds.height / 812
    static let widht = UIScreen.main.bounds.width / 375
}
