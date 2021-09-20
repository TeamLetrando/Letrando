//
//  ResultView.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 17/09/21.
//

import UIKit
import Lottie

class ResultView: UIView {
    
    private lazy var soundButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var resultMessage: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    private lazy var animationView: AnimationView = {
        let animation = AnimationView(name: "")
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        animation.animationSpeed = 0.8
        animation.play()
        return animation
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
}
