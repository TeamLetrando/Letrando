//
//  SearchView+ARDelegate.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import Foundation
import SceneKit
import ARKit

@available(iOS 13.0, *)
extension SearchViewController : ARSCNViewDelegate, ARSessionDelegate {
    
    func renderer (_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard !areLettersGenerated else { return }
        areLettersGenerated = true
        
        let letters = generateNodes(letters: word?.breakInLetters())
        addNodesToScene(nodes: letters)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if !areLettersAdded {
            areLettersAdded = true
            addNodesToGame(nodes: sceneController.textNode, parent: node)
        }
        delegate?.changeLettersStackHiding(for: !areLettersAdded)
        delegate?.changeMessageLabelHiding(for: areLettersAdded)
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        areLettersAdded = false
    }
}
