//
//  GameViewDelegate.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 21/09/21.
//

import UIKit
import ARKit

protocol GameViewDelegate: AnyObject {
    func changeMessageLabelHiding(for value: Bool)
    func changeLettersStackHiding(for value: Bool)
    func animateFeedBack(initialPosition: CGPoint, letter: String, sceneView: ARSCNView)
    func setHandButtonImage(for imageName: String)
}

protocol GameControlerDelegate: AnyObject {
    func backToHome()
}
