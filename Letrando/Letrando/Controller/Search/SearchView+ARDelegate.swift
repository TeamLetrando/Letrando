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
        if !planeAdded {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                plane = Plane(planeAnchor)
                node.addChildNode(plane!)
                self.planeAdded = true
                stack.isHidden = false
            }
        }

        DispatchQueue.main.async {
            if !self.lettersAdded {
                self.lettersAdded = true
                self.addWord(letters: self.letters)
                print(self.sceneController.textNode)
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            plane?.update(planeAnchor)
        }
    }
}
