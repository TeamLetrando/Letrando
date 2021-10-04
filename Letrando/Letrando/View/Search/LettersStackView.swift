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
        
        letters?.forEach {
            let image = UIImageView(image: UIImage(named: "lettersEmpty/\($0).pdf") )
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            image.layer.borderColor = UIColor.lightGray.cgColor
            image.layer.zPosition = -0.001
            image.layer.name = $0
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
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        }
    }
    
    func setupAditionalChanges() {
        self.axis = .horizontal
        self.distribution = .fillEqually
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
