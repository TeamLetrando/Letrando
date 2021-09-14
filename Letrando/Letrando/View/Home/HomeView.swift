//
//  HomeView.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import UIKit

class HomeView: UIView, ViewCodable {
    
    private lazy var soundButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mascotImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var lettersImage: UIImageView = {
        let letters = UIImageView()
        letters.translatesAutoresizingMaskIntoConstraints = false
        return letters
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func buildViewHierarchy() {
        addSubview(soundButton)
        addSubview(titleLabel)
        addSubview(mascotImage)
        addSubview(lettersImage)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
