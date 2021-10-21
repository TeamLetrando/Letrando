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
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let plane = Plane(planeAnchor)
        if !lettersAdded {
            self.planes.append(plane)
            node.addChildNode(plane)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard let plane  = self.planes.filter({ plane -> Bool in
            return plane.planeAnchor.identifier == anchor.identifier}).first else { return }
        addWord(letters: self.word?.breakInLetters() ?? [], plane: plane)
        
        delegate?.changeLettersStackHiding(for: !lettersAdded)
        delegate?.changeMessageLabelHiding(for: lettersAdded)
        
        plane.update(planeAnchor)
    }
}
