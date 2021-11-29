//
//  GameView.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 14/09/21.
//

import UIKit
import ARKit
import SoundsKit

protocol GameViewProtocol {
    init(letters: [String]?)
}

class GameView: UIView, ViewCodable, GameViewProtocol {
    
    private lazy var isDogAnimated = false
    private var stackWidthConstraint: NSLayoutConstraint?
    weak var delegate: GameControlerDelegate?
    private var userDefaults = UserDefaults.standard
    
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
        let button = RoundedButton(backgroundImage: UIImage(named: ImageAssets.handButtonOn.rawValue),
                                   buttonAction: handButtonAction,
                                   tintColor: .greenActionLetrando)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backToHomeButton: UIButton = {
        let button = RoundedButton(backgroundImage: UIImage(systemName: SystemIcons.back.rawValue),
                                   buttonAction: backToHomeButtonAction,
                                   tintColor: .greenActionLetrando)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    required convenience init(letters: [String]?) {
        self.init()
        lettersStackView.letters = letters
    }

    private lazy var dogSearchingImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageAssets.mascotSearchingImage.rawValue)
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.isHidden = true
        return image
    }()
    
    override func didMoveToSuperview() {
        setupView()
    }
    
    func buildViewHierarchy() {
        addSubview(backToHomeButton)
        addSubview(handButton)
        addSubview(dogSearchingImageView)
        addSubview(findAnotherPlaceMessageLabel)
        addSubview(lettersStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backToHomeButton.heightAnchor.constraint(equalToConstant: 50 * Multipliers.height),
            backToHomeButton.widthAnchor.constraint(equalToConstant: 50 * Multipliers.height),
            backToHomeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                  constant: 16 * Multipliers.height),
            
            backToHomeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16 * Multipliers.widht),
            
            handButton.heightAnchor.constraint(equalToConstant: 50 * Multipliers.height),
            handButton.widthAnchor.constraint(equalToConstant: 50 * Multipliers.height),
            handButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16 * Multipliers.height),
            handButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16 * Multipliers.widht),
            
            findAnotherPlaceMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            findAnotherPlaceMessageLabel.topAnchor.constraint(equalTo: backToHomeButton.bottomAnchor,
                                                              constant: 20 * Multipliers.height),
            findAnotherPlaceMessageLabel.widthAnchor.constraint(equalTo: widthAnchor),
            
            lettersStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lettersStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            dogSearchingImageView.heightAnchor.constraint(equalToConstant: 250 * Multipliers.height),
            dogSearchingImageView.widthAnchor.constraint(equalToConstant: 200 * Multipliers.widht),
            dogSearchingImageView.topAnchor.constraint(equalTo:
                                                        findAnotherPlaceMessageLabel.bottomAnchor,
                                                       constant: 20 * Multipliers.height),
            dogSearchingImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -200 * Multipliers.widht)
        ])
    }
    
    func setWidthStackConstraint(width: CGFloat) {
        stackWidthConstraint?.isActive = false
        stackWidthConstraint = lettersStackView.widthAnchor.constraint(equalToConstant: width * 0.9)
        stackWidthConstraint?.isActive = true
        
        setNeedsLayout()
    }
    
    func setupAditionalChanges() {
        feedbackGenerator.prepare()
        let isAnimationEnable = UserDefaults.standard.bool(forKey: UserDefaultsKey.animationFeedback.rawValue)
        setHandButtonImage(for: isAnimationEnable ? ImageAssets.handButtonOn.rawValue :
                                ImageAssets.handButtonOff.rawValue)
    }
    
    func feedbackGeneratorImpactOccurred() {
        feedbackGenerator.impactOccurred()
    }
    
    @objc private func handButtonAction() {
        let isAnimationEnable = UserDefaults.standard.bool(forKey: UserDefaultsKey.animationFeedback.rawValue)
        UserDefaults.standard.set(!isAnimationEnable, forKey: UserDefaultsKey.animationFeedback.rawValue)
        setHandButtonImage(for: !isAnimationEnable ? ImageAssets.handButtonOn.rawValue :
                                ImageAssets.handButtonOff.rawValue)
    }
    
    @objc private func backToHomeButtonAction() {
        self.dogSearchingImageView.isHidden = true
        dogSearchingImageView.layer.removeAllAnimations()
        delegate?.backToHome()
    }
    
    private func dogSearchingImageViewAnimation() {
        let initialPositionX = dogSearchingImageView.layer.position.x
        dogSearchingImageView.isHidden = false
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [.curveEaseInOut],
                       animations: {
            self.dogSearchingImageView.layer.position.x = initialPositionX + (200 * Multipliers.widht)
        }, completion: { [weak self] _ in
            self?.animateDogOut(initialPositionX)
        })
            try? SoundsKit.playAlert()
    }
    
    private func animateDogOut(_ initialPositionX: CGFloat) {
        UIView.animate(withDuration: 1.0, delay: 2.0, animations: { [weak self] in
            self?.dogSearchingImageView.layer.position.x = initialPositionX - (200 * Multipliers.widht)
        }, completion: { [weak self] _ in
            self?.dogSearchingImageView.isHidden = true
        })
    }
}

extension GameView: GameViewDelegate {
    
    func changeMessageLabelHiding(for value: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.findAnotherPlaceMessageLabel.isHidden = value
            if !(self?.isDogAnimated ?? false) &&
               !(self?.userDefaults.bool(forKey: UserDefaultsKey.onboardingIsOn.rawValue) ?? false) {
                self?.dogSearchingImageViewAnimation()
                self?.isDogAnimated = true
            }
        }
    }
    
    func changeLettersStackHiding(for value: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.lettersStackView.isHidden = value
        }
    }
    
    func animateFeedBack(initialPosition: CGPoint, letter: String, sceneView: ARSCNView) {
        if !UserDefaults.standard.bool(forKey: UserDefaultsKey.animationFeedback.rawValue) {
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
                handImage.image = UIImage(named: ImageAssets.handAnimation.rawValue)
                
                sceneView.addSubview(handImage)
                
                UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                    handImage.layer.position = finalPosition
                }, completion: { _ in
                    handImage.removeFromSuperview()
                })
            }
        }
    }
    
    func setHandButtonImage(for imageName: String) {
        DispatchQueue.main.async { [weak self] in
            self?.handButton.setImage(UIImage(named: imageName), for: .normal)
            self?.layoutIfNeeded()
        }
    }
}

enum Multipliers {
    static let screenSize = UIScreen.main.bounds.size
    static let height = UIScreen.main.bounds.height / 812
    static let widht = UIScreen.main.bounds.width / 375
}
