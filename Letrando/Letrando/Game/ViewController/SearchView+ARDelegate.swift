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
        guard !isPlaneAdded else { return }
        isPlaneAdded = true
        
        let plane = generatePlane(anchor: anchor)
        node.addChildNode(plane)
        
        let nodes = generateNodes(word: word)
        generatePositions(planeSize: CGSize(width: plane.width, height: plane.height), nodes: nodes)
        addNodesToPlane(plane: plane, nodes: nodes)
        
        delegate?.changeLettersStackHiding(for: !isPlaneAdded)
        delegate?.changeMessageLabelHiding(for: isPlaneAdded)
    }
    
    func generatePlane(anchor: ARAnchor) -> Plane {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { fatalError("Fail to cast to ARPlaneAnchor") }
        return Plane(planeAnchor)
    }
    
    func getNodeFromFile(name: String, format: String) -> SCNNode? {
        guard let urlPath = Bundle.main.url(forResource: name,
                                            withExtension: format) else {
            fatalError("Fail to get url of file \(name).\(format)") }
        
        let scene = try? SCNScene(url: urlPath, options: [.checkConsistency: true])
        let node = scene?.rootNode
        node?.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        node?.physicsBody?.categoryBitMask = BodyType.letter.rawValue
        node?.scale = SCNVector3(Float(0.02), Float(0.02), Float(0.02))
        node?.name = name.uppercased()
        
        return node
    }
    
    func generateNodes(word: Word?) -> [SCNNode?] {
        let letters = word?.breakInLetters()
        var nodes: [SCNNode?] = []
        letters?.forEach { letter in
            nodes.append(getNodeFromFile(name: letter, format: "usdz"))
        }
        return nodes
    }
    
    func addNodesToPlane(plane: Plane, nodes: [SCNNode?]) {
        nodes.forEach { node in
            plane.addChildNode(node ?? SCNNode())
            sceneController.addLetterToScene(letterNode: node ?? SCNNode())
        }
    }
    
}
