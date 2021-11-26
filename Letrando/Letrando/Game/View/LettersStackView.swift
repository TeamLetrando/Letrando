//
//  StackLettersView.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 14/09/21.
//

import UIKit

class LettersStackView: UIStackView, ViewCodable {
    
    private lazy var lettersImagesView: [UIImageView] = {
        var images = [UIImageView]()
       
        letters?.forEach { letter in
            let imageLetter = UIImage(named: String(format: ImageAssets.letterStackEmpty.rawValue, letter))
            let image = UIImageView(image: imageLetter)
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            image.layer.borderColor = UIColor.lightGray.cgColor
            image.layer.zPosition = -0.001
            image.layer.name = letter
            image.translatesAutoresizingMaskIntoConstraints = false
            images.append(image)
        }
        
        return images
    }()
    
    var letters: [String]?
    
    override func didMoveToSuperview() {
        setupView()
    }
    
    func buildViewHierarchy() {
        lettersImagesView.forEach { [weak self] in
            self?.addArrangedSubview($0)
        }
    }
    
    func setupConstraints() {
        lettersImagesView.forEach {
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.18).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        }
    }
    
    func setupAditionalChanges() {
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.alignment = .center
        self.spacing = 15
        self.isHidden = true
    }
    
    override func layoutSubviews() {
        lettersImagesView.forEach {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5.0
            $0.layer.borderWidth = 1.0
        }
    }
}
