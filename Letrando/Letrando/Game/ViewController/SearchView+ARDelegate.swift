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
        guard !isLettersGenerated else { return }
        isLettersGenerated = true
        
        let letters = generateNodes(word: word)
        generatePositions(planeSize: planeSize, nodes: letters)
        addNodesToScene(nodes: letters)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if !isLettersAdded {
            isLettersAdded = true
            showLetters(nodes: sceneController.textNode, parent: node)
        }
        
        delegate?.changeLettersStackHiding(for: !isLettersAdded)
        delegate?.changeMessageLabelHiding(for: isLettersAdded)
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        isLettersAdded = false
    }
 
    private func getNodeFromFile(name: String, format: String) -> SCNNode? {
        guard let urlPath = Bundle.main.url(forResource: name,
                                            withExtension: format) else {
            fatalError("Fail to get url of file \(name).\(format)") }
        
        let scene = try? SCNScene(url: urlPath, options: [.checkConsistency: true])
        let node = scene?.rootNode
        node?.geometry = SCNGeometry()
        node?.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        node?.physicsBody?.categoryBitMask = BodyType.letter.rawValue
        node?.scale = SCNVector3(Float(0.02), Float(0.02), Float(0.02))
        node?.name = name
        
        return node
    }
    
    private func generateNodes(word: Word?) -> [SCNNode?] {
        let letters = word?.breakInLetters()
        var nodes: [SCNNode?] = []
        letters?.forEach { letter in
            nodes.append(getNodeFromFile(name: letter, format: "usdz"))
        }
        return nodes
    }
    
    private func addNodesToScene(nodes: [SCNNode?]) {
        nodes.forEach { node in
            sceneController.addLetterToScene(letterNode: node ?? SCNNode())
        }
    }
    
    private func showLetters(nodes: [SCNNode?], parent: SCNNode) {
        nodes.forEach { node in
            node?.removeFromParentNode()
            parent.addChildNode(node ?? SCNNode())
        }
    }
}
